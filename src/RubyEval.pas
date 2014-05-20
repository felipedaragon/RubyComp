{ $Id: RubyEval.pas,v 1.3 2003/11/01 15:21:55 pka Exp $

  Copyright (C) 2003 Sourcepole AG
  Author: Pirmin Kalberer <pi@sourcepole.com>
  License: MPL1.1 <http://www.opensource.org/licenses/mozilla1.1.php>

  Felipe Daragon, 2014, changed:
  - Added TRubyPrintProc and DelphiIO_puts()
}

unit RubyEval;

interface

{$DEFINE RUBY18}

uses
  SysUtils, Classes, RubyWrapper;

//Global procedures/functions for all instances of TRubyEval

//Additional Output to TStrings object (e.g. TMemo.Lines)
procedure AssignOutput(newout: TStrings);
//Clear Output (Property and assigned TStrings Object)
procedure ResetOutput;
//Remove additionally assigned TStrings output
procedure RemoveOutput;
//Remove redirection of stdout and stderr
procedure RemoveIORedirection;
//Redirect stdout and stderr to Output (default)
procedure RedirectIO;
//Convert Ruby value to string
function ValToStr(const rval: Tvalue): String;

type
  TRubyPrintProc = procedure(msg:string);


type
  TRubyEval = class(TComponent)
  private
    { Private-Deklarationen }
    state: Integer;

    FExceptions: Boolean;
    FExpression: TStringList;
    FErrorInfo: String;

    procedure SetExpression(const Value: TStringList);
    function GetOutput: String;
    procedure InitInterpreter;
    // Set error information or raise exception if necessary (returns EvalOk)
    function CheckState: Boolean;
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    //Output of evaluation
    property Output: String read GetOutput;
    //Ruby error message of last evaluation
    property ErrorInfo: String read FErrorInfo;
    // Evaluate given expression
    function EvalExpression(const expr: String): Variant;
    // Run script file
    procedure EvalFile(const filename: String);
    // Last evaluation was successful
    function EvalOk: Boolean;
    // Evaluate expression
    function Execute: Variant;
  published
    { Published-Deklarationen }
    //Raise Delphi exception on Ruby error
    property Exceptions: Boolean read FExceptions write FExceptions default false;
    //Ruby Expression for evaluation (Execute)
    property Expression: TStringList read FExpression write SetExpression;
  end;

var
  RubyPrintProc:TRubyPrintProc;

procedure Register;
function DelphiIO_puts(This, v: Tvalue): Tvalue; cdecl; // syhunt

implementation

uses Variants, uConv;

var
  OutBuf: string;
  OutputStrings: TStrings;
  orig_stdin, orig_stdout, orig_stderr: Tvalue;
{$IFNDEF RUBY18}
  orig_defout: Tvalue;
{$ENDIF}
  cDelphiIO: Tvalue = 0;
  vDelphiIO: Tvalue = 0;


procedure Register;
begin
  RegisterComponents('Scripting', [TRubyEval]);
end;
constructor TRubyEval.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  state := 0;
  FExpression := TStringList.Create;
  InitInterpreter;
end;

destructor TRubyEval.Destroy;
begin
  inherited Destroy;
end;

procedure TRubyEval.SetExpression(const Value: TStringList);
begin
  FExpression.Assign(Value);
end;

function TRubyEval.GetOutput: String;
begin
  Result := OutBuf;
end;

// -- Based on Pseudo.pas by Kazuhiro Yoshida --

function DelphiIO_write(This, v: Tvalue): Tvalue; cdecl;
var
  str: Tvalue;
  len: Integer;
begin
  str := v;
  if RTYPE(str) <> T_STRING then str := rb_obj_as_string(str);
  len := ap_str_len(str);
  if len <> 0 then
  begin
    OutBuf := OutBuf + dl_String(str);

    if Assigned(OutputStrings) then
      OutputStrings.Text := OutBuf;
  end;
  result := INT2FIX(len);
end;

function DelphiIO_gets(This: Tvalue): Tvalue; cdecl;
var
  S: string;
begin
  readln(S);
  if Length(S) <> 0 then // 0 if \C-z. Eof cannot use This case.
    if S[1] = #4{\C-d} then SetLength(S, 0)
    else S := S + #10;

  if Length(S) = 0 then
    result := Qnil
  else
    result := rb_str_new2(PChar(S))
  ;
  rb_lastline_set(result); // $_ set
end;

function DelphiIO_getc(This: Tvalue): Tvalue; cdecl;
var
  c: Char;
begin
  read(c);
  if c = #0 then
    result := Qnil
  else
    result := CHR2FIX(c)
  ;
end;

procedure RedirectIO;
begin
  ap_set_stdin (vDelphiIO);
  ap_set_stdout(vDelphiIO);
  ap_set_stderr(vDelphiIO);
{$IFNDEF RUBY18}
  ap_set_defout(vDelphiIO);
{$ENDIF}
end;

procedure RemoveIORedirection;
begin
  ap_set_stdin (orig_stdin );
  ap_set_stdout(orig_stdout);
  ap_set_stderr(orig_stderr);
{$IFNDEF RUBY18}
  ap_set_defout(orig_defout);
{$ENDIF}
end;

// --

procedure AssignOutput(newout: TStrings);
begin
  OutBuf := '';
  OutputStrings := newout;
end;

procedure ResetOutput;
begin
  OutBuf := '';
  if Assigned(OutputStrings) then
    OutputStrings.Text := OutBuf;
end;

procedure RemoveOutput;
begin
  OutputStrings := nil;
end;

function ValToStr(const rval: Tvalue): String;
var
  rbstr: Tvalue;
begin
  rbstr := rval;
  if RTYPE(rbstr) <> T_STRING then rbstr := rb_obj_as_string(rval);
  Result := dl_String(rbstr);
end;

function DelphiIO_puts(This, v: Tvalue): Tvalue; cdecl; // syhunt
var str: Tvalue; len: Integer;
begin
  str := v;
  if RTYPE(str) <> T_STRING then str := rb_obj_as_string(str);
  len := ap_str_len(str);
  if len <> 0 then
  begin
    if Assigned(RubyPrintProc) then
     RubyPrintProc(dl_String(str));
  end;
  result := INT2FIX(len);
end;

procedure TRubyEval.InitInterpreter;
begin
  if vDelphiIO = 0 then //only once!
  begin
    ruby_init();
    ruby_init_loadpath();
    rb_set_safe_level(0);
    ruby_script('ruby');

    cDelphiIO := rb_class_new(ap_cIO);
    rb_define_module_function(cDelphiIO, 'write', @DelphiIO_write, 1);
    rb_define_module_function(cDelphiIO, 'gets', @DelphiIO_gets, 0);
    rb_define_module_function(cDelphiIO, 'getc', @DelphiIO_getc, 0);
    vDelphiIO := rb_data_object_alloc(cDelphiIO, nil, nil, nil);
    rb_global_variable(@vDelphiIO);

    orig_stdin  := ap_stdin ;
    orig_stdout := ap_stdout;
    orig_stderr := ap_stderr;
{$IFNDEF RUBY18}
    orig_defout := ap_defout;
{$ENDIF}

    RedirectIO;
  end
end;

function TRubyEval.CheckState: Boolean;
begin
  Result := (state = 0);
  if state <> 0 then
  begin
    FErrorInfo := ValToStr(ap_errinfo);
    if FExceptions then
      raise Exception.Create(FErrorInfo);
  end
  else
    FErrorInfo := '';
end;

function TRubyEval.EvalExpression(const expr: String): Variant;
var
  rval: Tvalue;
begin
  rval := rb_eval_string_protect(PChar(expr), state);
  if CheckState then
    Result := dl_Variant(rval)
  else
    Result := Unassigned;
end;

procedure TRubyEval.EvalFile(const filename: String);
begin
  {//ruby_options(intargc, char**argv")
    argc := args.count;
    SetLength(argv, argc);
    for i := 0 to argc-1 do argv[i] := PChar(args[i]);
    ruby_set_argv(argc, argv);
  }
  rb_load_protect(ap_String(filename), 0, state);
  CheckState;
end;

function TRubyEval.EvalOk: Boolean;
begin
  Result := (state = 0);
end;

function TRubyEval.Execute: Variant;
begin
  Result := EvalExpression(FExpression.Text);
end;

end.

