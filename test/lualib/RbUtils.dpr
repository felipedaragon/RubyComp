library RbUtils;

{
 Ruby Utilities for Lua
 
  Copyright (c) 2003-2014 Felipe Daragon
  License: MIT (http://opensource.org/licenses/mit-license.php)
}

uses
  Lua, RubyUtils;

{$R *.res}

function lua_coderay_highlight(L: plua_State):integer; cdecl;
var r:string;
begin
 r:=CodeRay_Highlight(lua_tostring(L,1),lua_tostring(L,2));
 lua_pushstring(L,pchar(r));
 result:=1;
end;

function luaopen_RbUtils(L: plua_State):integer; cdecl;
const
 rb_table : array [1..2] of luaL_reg =
 (
 (name:'coderay_highlight';func:lua_coderay_highlight),
 (name:nil;func:nil) // needed
  );
begin
 lual_register(L,'rbutils',@rb_table);
 Result := 0;
end;

Exports
 luaopen_RbUtils;

begin
end.
