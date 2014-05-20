unit st;

interface

uses SysUtils;

const
  ST_DEFAULT_MAX_DENSITY = 5;
  ST_DEFAULT_INIT_TABLE_SIZE = 11;

type
  PSTHashType = ^TSTHashType;
  TSTHashType = record
    compare: function(var x, y): Integer;
    hash: function(var x): Integer;
  end;

  PSTTableEntry = ^TSTTableEntry;
  PPSTTableEntry = ^PSTTableEntry;
  TSTTableEntry = record
    hash: Cardinal;
    key, value: Pointer;
    next: PSTTableEntry;
  end;

  PSTTable = ^TSTTable;
  TSTTable = record
    hash_type: PSTHashType;
    num_bins, num_entries: Cardinal;
    bins: PPSTTableEntry;
  end;

  TSTRetval = (stCONTINUE, stSTOP, stDELETE);

  TSTFnEach = function(key, value: Pointer; arg: Pointer): TSTRetval;

function st_init_table(hash_type: PSTHashType): PSTTable;
function st_init_table_with_size(hash_type: PSTHashType; size: Integer): PSTTable;
{
  TSTTable を作成する。 _with_size はサイズを指定して生成する。
  TSTHashType はハッシュ値を得る関数と同値判定を行う関数を持つ。
}

function st_init_numtable: PSTTable;
function st_init_numtable_with_size(size: Integer): PSTTable;
{
  Longint のハッシュを作成する。
  st_init_table に Longint 用の操作関数を渡しているだけ。
}

function st_init_strtable: PSTTable;
function st_init_strtable_with_size(size: Integer): PSTTable;
{
  pchar 用のハッシュを作成する。
  st_init_table に pchar 用の操作関数を渡しているだけ。
}

procedure st_free_table(table: PSTTable);
{
  table を解放する。キーと値は解放されない。
}

function st_insert(table: PSTTable; var key; var value: Pointer): boolean;
{
  ハッシュに key と value の組を追加する。
}

function st_lookup(table: PSTTable; var key; var value: Pointer): boolean;
{
  key に対応する値をみつけて value にポインタを書きこむ。
  返り値は見つかったかどうかの真偽値。 
}

function st_is_member(table: PSTTable; var key): boolean;
{
  key が table に登録されているかどうか調べる。
}

procedure st_add_direct(table: PSTTable; var key; var value: Pointer);
{
  st_insert() と似ているが、同じハッシュ値を持つエントリーに対する「同値検査」を省略する。
  key がまだ登録されていないことがはっきりしている場合には、少し高速に登録できる。
}

function st_copy(old_table: PSTTable): PSTTable;
{
  Hash#dup の実体。
  old_table と同じ内容の TSTTable を新たに作成して返す。
}

function st_delete(table: PSTTable; var key, value: Pointer): boolean;
{
  key に対応する値をテーブルから削除し、key, value に登録時のキーと値を書きこむ。
  返り値は削除したかどうか。 
}

function st_delete_safe(table: PSTTable; var key, value: Pointer; never: Pointer): boolean;
{
  st_delete() と似ているが、その場ですぐに削除するのではなく never を書きこんでおく。st_cleanup_safe() で本当に削除できる。
  Ruby では never には Qundef を使う。
}

procedure st_foreach(table: PSTTable; func: TSTFnEach; arg: Pointer);
{
  Hash#each, delete_if などの実体。ハッシュ内の全てのキーと値(と arg)を引数にして func を実行する。
  func の返り値 enum st_retval は ST_CONTINUE ST_STOP ST_DELETE のどれか。どれも見ためどおりの働きをする。 
}

procedure st_cleanup_safe(table: PSTTable; never: Pointer);
{
  never と同じ値を持つエントリーを削除する。
}

implementation

function strcmp(var x, y): Integer;
begin
  result := strcomp(pchar(x), pchar(y));
end;

function strhash(var x): Integer;
var
  c: pchar;
  h, g: Cardinal;
begin
  // HASH_ELFHASH
  c := pchar(x);
  h := 0;
  while c <> #0 do
  begin
    h := (h shl 4) + Cardinal(c);
    g :=  h and $F000000;
    if g <> 0 then h := h xor (g shr 24);
    h :=  h and not g;
  end;
  result := h;
end;

function numcmp(var x, y): Integer;
begin
  if Longint(x) < Longint(y) then result := -1
  else
  if Longint(x) = Longint(y) then result :=  0
  else
//  if Longint(x) > Longint(y) then
    result :=  1;
end;

function numhash(var x): Integer;
begin
  result := Longint(x);
end;

const
  MINSIZE = 8;
  primes: array[0..3] of Longint = (
    8+3,
    16+3,
    32+5,
    0
  );
  type_numhash: TSTHashType = (
    compare: numcmp;
    hash: numhash
  );
  type_strhash: TSTHashType = (
    compare: strcmp;
    hash: strhash
  );

function new_size(size: Integer): Integer;
var
  i: Integer;
  newsize: Integer;
begin
  newsize := MINSIZE;
  for i := 0 to sizeof(primes) div sizeof(primes[0]) - 1 do
  begin
    if newsize > size then begin result := primes[i]; exit; end;
    newsize := newsize shl 1;
  end;
  result := -1;
end;

function st_init_table_with_size(hash_type: PSTHashType; size: Integer): PSTTable;
begin
  size := new_size(size);
  new(result);
  result.hash_type := hash_type;
  result.num_entries := 0;
  result.num_bins := size - 1;
  getmem(result.bins, size*sizeof(PSTTableEntry));
end;

function st_init_table(hash_type: PSTHashType): PSTTable;
begin
  result := st_init_table_with_size(hash_type, 0);
end;

function st_init_numtable: PSTTable;
begin
  result := st_init_table(@type_numhash);
end;

function st_init_numtable_with_size(size: Integer): PSTTable;
begin
  result := st_init_table_with_size(@type_numhash, size);
end;

function st_init_strtable: PSTTable;
begin
  result := st_init_table(@type_strhash);
end;

function st_init_strtable_with_size(size: Integer): PSTTable;
begin
  result := st_init_table_with_size(@type_strhash, size);
end;

procedure st_free_table(table: PSTTable);
var
  bin: PPSTTableEntry;
  ptr, next: PSTTableEntry;
  i: Integer;
begin
  bin := table.bins;
  for i := 0 to table.num_bins do
  begin
    ptr := bin^;
    while assigned(ptr) do
    begin
      next := ptr.next;
      freemem(ptr);
      ptr := next;
    end;
    inc(bin);
  end;
  freemem(table.bins);
  dispose(table);
end;

function equal(table: PSTTable; var x, y): boolean;
begin
  result := (Pointer(x) = Pointer(y)) or (table^.hash_type.compare(x, y) = 0)
end;

function do_hash(var key; table: PSTTable): Cardinal;
var
  hash: function(var x): Integer;
begin
  hash := table^.hash_type.hash;
  result := hash(key);
end;

function do_hash_bin(var key; table: PSTTable): Cardinal;
begin
  result := do_hash(key, table) mod table^.num_bins;
end;

function ptr_not_equal(table: PSTTable; ptr: PSTTableEntry; hash_val: Cardinal; var key): boolean;

begin
  result := assigned(ptr) and ((ptr^.hash <> hash_val) or not equal(table, key, ptr^.key))
end;

procedure collision;
begin
//
end;

procedure find_entry(table: PSTTable; var ptr: PSTTableEntry; hash_val: Cardinal; var bin_pos: Integer; var key);
var
  bin: PPSTTableEntry;
begin
  bin_pos := hash_val mod table.num_bins;
  bin := table.bins;
  inc(bin, bin_pos);
  ptr := bin^;
  if ptr_not_equal(table, ptr, hash_val, key) then
  begin
    collision;
    while ptr_not_equal(table, ptr.next, hash_val, key) do
      ptr := ptr.next;
    ptr := ptr.next;
  end;
end;

function st_lookup(table: PSTTable; var key; var value: Pointer): boolean;
var
  hash_val: Cardinal;
  bin_pos: Integer;
  ptr: PSTTableEntry;
begin
  hash_val := do_hash(key, table);
  find_entry(table, ptr, hash_val, bin_pos, key);
  if ptr = nil then
    result := false
  else begin
    if assigned(value) then value := ptr^.value;
    result := true
  end
end;

function st_is_member(table: PSTTable; var key): boolean;
var
  v, z: Pointer;
begin
  z := @v;
  result := st_lookup(table, key, z);
end;

procedure rehash(table: PSTTable);
var
  ptr, next: PSTTableEntry;
  new_bins: PPSTTableEntry;
  i: Integer;
  old_num_bins, new_num_bins: Cardinal;
  hash_val: Cardinal;

  bin, new_bin: PPSTTableEntry;
  new_ptr: PSTTableEntry;

begin
  old_num_bins := table^.num_bins;
  new_num_bins := new_size(old_num_bins+1);
  getmem(new_bins, new_num_bins*sizeof(PSTTableEntry));
  dec(new_num_bins);
  bin := table.bins;
  for i := 0 to old_num_bins do
  begin
    ptr := bin^;
    while assigned(ptr) do
    begin
      next := ptr^.next;
      hash_val := ptr^.hash mod new_num_bins;

      new_bin := new_bins;
      inc(new_bin, hash_val);
      new_ptr := new_bin^;

      ptr^.next := new_ptr;
      new_bin^ := ptr;

      ptr := next;
    end;
    inc(bin);
  end;
  freemem(table^.bins);
  table^.num_bins := new_num_bins;
  table^.bins := new_bins;
end;

procedure add_direct(table: PSTTable; var key; var value: Pointer; hash_val: Cardinal; var bin_pos: Integer);
var
  bin: PPSTTableEntry;
  ptr, entry: PSTTableEntry;
begin
  if table^.num_entries div (table^.num_bins+1) > ST_DEFAULT_MAX_DENSITY then
  begin
    rehash(table);
    bin_pos := hash_val mod table^.num_bins;
  end;

  new(entry);

  bin := table.bins;
  inc(bin, bin_pos);
  ptr := bin^;

  entry^.hash := hash_val;
  entry^.key := Pointer(key);
  entry^.value := value;
  entry^.next := ptr;
  bin^ := entry;
  inc(table^.num_entries);
end;

procedure st_add_direct(table: PSTTable; var key; var value: Pointer);
var
  hash_val: Cardinal;
  bin_pos: Integer;
begin
  hash_val := do_hash(key, table);
  bin_pos := hash_val mod table^.num_bins;
  add_direct(table, key, value, hash_val, bin_pos);
end;

function st_insert(table: PSTTable; var key; var value: Pointer): boolean;
var
  hash_val: Cardinal;
  bin_pos: Integer;
  ptr: PSTTableEntry;
begin
  hash_val := do_hash(key, table);
  find_entry(table, ptr, hash_val, bin_pos, key);
  if ptr = nil then begin
    add_direct(table, key, value, hash_val, bin_pos);
    result := false
  end else begin
    ptr^.value := value;
    result := true
  end
end;

function st_copy(old_table: PSTTable): PSTTable;
var
  new_table: PSTTable;
  ptr, entry: PSTTableEntry;
  old_bins, new_bins: PPSTTableEntry;
  i: Integer;
  num_bins: Cardinal;

begin
  num_bins := old_table^.num_bins+1;
  new(new_table);
  if not assigned(new_table) then begin result := nil; exit end;
  new_table^ := old_table^;
  getmem(new_table^.bins, num_bins*sizeof(PSTTableEntry));
  if not assigned(new_table^.bins) then begin result := nil; exit end;
  
  new_bins := new_table^.bins;
  old_bins := old_table^.bins;
  for i := 0 to num_bins - 1 do
  begin
    new_bins^ := nil;
    ptr := old_bins^;
    while assigned(ptr) do
    begin
      new(entry);
      if not assigned(entry) then
      begin
        freemem(new_table^.bins);
        dispose(new_table);
        result := nil;
        exit
      end;
      entry^ := ptr^;
      entry^.next := new_bins^;
      new_bins^ := entry;
      ptr := ptr^.next;
    end
  end;
  result := new_table
end;

function st_delete(table: PSTTable; var key, value: Pointer): boolean;
var
  hash_val: Cardinal;
  bin: PPSTTableEntry;
  ptr, tmp: PSTTableEntry;
begin
  hash_val := do_hash_bin(key^, table);
  bin := table^.bins;
  inc(bin, hash_val);
  ptr := bin^;
  if not assigned(ptr) then
  begin
    if assigned(value) then value := nil;
    result := false;
    exit
  end;
  if equal(table, key^, ptr^.key) then
  begin
    bin^ := ptr^.next;
    dec(table^.num_entries);
    if assigned(value) then value := ptr^.value;
    key := ptr^.key;
    freemem(ptr);
    result := true;
    exit
  end;
  while assigned(ptr^.next) do
  begin
    if equal(table, ptr^.next^.key, key^) then
    begin
      tmp := ptr^.next;
      ptr^.next := ptr^.next^.next;
      dec(table^.num_entries);
      if assigned(value) then value := tmp^.value;
      key := tmp^.key;
      freemem(tmp);
      result := true;
      exit
    end;
    ptr := ptr^.next
  end;
  result := false
end;

function st_delete_safe(table: PSTTable; var key, value: Pointer; never: Pointer): boolean;
var
  hash_val: Cardinal;
  bin: PPSTTableEntry;
  ptr: PSTTableEntry;
begin
  hash_val := do_hash_bin(key^, table);
  bin := table^.bins;
  inc(bin, hash_val);
  ptr := bin^;
  if not assigned(ptr) then
  begin
    if assigned(value) then value := nil;
    result := false;
    exit
  end;
  while assigned(ptr^.next) do
  begin
    if not (ptr^.key = never) and equal(table, ptr^.key, key^) then
    begin
      dec(table^.num_entries);
      key := ptr^.key;
      if assigned(value) then value := ptr^.value;
      ptr^.key := never;
      ptr^.value := never;
      result := true;
      exit
    end;
    ptr := ptr^.next
  end;
  result := false
end;

function delete_never(key, value, never: Pointer): TSTRetval;
begin
  if value = never then result := stDELETE
  else result := stCONTINUE;
end;

procedure st_foreach(table: PSTTable; func: TSTFnEach; arg: Pointer);
var
  bin: PPSTTableEntry;
  ptr, last, tmp: PSTTableEntry;
  retval: TSTRetval;
  i: Integer;
begin
  for i := 0 to table^.num_bins do
  begin
    last := nil;
    bin := table^.bins;
    inc(bin, i);
    ptr := bin^;
    while assigned(ptr) do
    begin
      retval := func(ptr^.key, ptr^.value, arg);
      case retval of
      stCONTINUE:
        begin
          last := ptr;
          ptr := ptr^.next;
        end;
      stSTOP:
          exit;
      stDELETE:
        begin
          tmp := ptr;
          if last = nil then
            bin^ := ptr^.next
          else
            last^.next := ptr^.next;
          ptr := ptr^.next;
          freemem(tmp);
          dec(table^.num_entries)
        end;
      end;
    end;
  end;
end;

procedure st_cleanup_safe(table: PSTTable; never: Pointer);
var
  num_entries: Cardinal;
begin
  num_entries := table^.num_entries;
  st_foreach(table, delete_never, never);
  table^.num_entries := num_entries;
end;

end.

