unit RubyUtils;
{
  Ruby Utils

  Copyright (c) 2003-2014 Felipe Daragon
  License: MIT (http://opensource.org/licenses/mit-license.php)
}

interface

uses
  RubyEval, RubyWrapper;

function CodeRay_Highlight(source, format: string): string;

implementation

const
  CRLF = #13 + #10;

function CodeRay_Highlight(source, format: string): string;
var
  obj: TRubyEval;
  script: string;
begin
  obj := TRubyEval.Create(nil);
  rb_define_global_const(pchar('Source'), rb_str_new(pchar(source),
    length(source)));
  script := 'require ''coderay''';
  script := script + CRLF + 'CodeRay.scan(Source, :' + format +
    ').span(:wrap=>:page)';
  result := obj.EvalExpression(script);
  obj.free;
end;

// ------------------------------------------------------------------------//
end.
