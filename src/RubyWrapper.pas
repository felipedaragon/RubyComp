{ $Id: RubyWrapper.pas,v 1.1.1.1 2003/10/31 13:26:23 pka Exp $

  Author: Kazuhiro Yoshida
  Modifications: Pirmin Kalberer <pi@sourcepole.com>
                 Felipe Daragon (FD)

  Changes:
  * 15.11.2015, FD - Added support for Delphi XE2 or higher.
  * 15.11.2015, FD - Replaced ASM code for 64-bit compilation.
}

unit RubyWrapper;

interface

{$DEFINE RUBY18}


uses
{$IFDEF LINUX}
  Libc,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SysUtils, st;

resourcestring
  sWrong_num_of_args = 'wrong # of arguments';
  sWrong_arg_type = 'wrong argument type';
  sToo_few_args = 'too few arguments';
  sToo_many_args = 'too many arguments';
  sOut_of_range = 'out of range';

{$IFDEF MSWINDOWS}
const
  NL = #13#10;
{$ENDIF}

{$IFDEF LINUX}
const
  NL = #10;
{$ENDIF}


{$I type.pas}

{$I funcint.pas}
{$I gvarint.pas}
{$I wrapint.pas}
{$I macroint.pas}

var
  RuntimeRubyDLL: array[0..MAX_PATH] of AnsiChar = RubyDLL;

implementation

uses uStrUtils;

{$I funcimp.pas}
{$I wrapimp.pas}
{$I macroimp.pas}

end.
