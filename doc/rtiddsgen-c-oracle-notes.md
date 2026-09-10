rtiddsgen 4.7.0 C oracle notes (-language C, -d <dir>)
=======================================================

Command:  rtiddsgen -d <out> -language C <file>.idl
(cl.exe on PATH required for the preprocessor; #include files need it.
ALWAYS prepend to PATH:
C:\Program Files\Microsoft Visual Studio\18\Insiders\VC\Tools\MSVC\14.44.35207\bin\Hostx86\x86)

## File layout (per IDL file, ALL types flattened into 6 files)
<IDLBase>.h          - consts (#define), typedefs, enums, struct defs,
                       union structs, ALL fn decls
<IDLBase>.c          - per type: TYPENAME def, get_typecode (member
                       table + annotations), get_sample_access_info
                       (offsetof), get_type_plugin_info,
                       initialize/_w_params/_ex, finalize*,
                       finalize_optional_members, copy, TSeq block
<IDLBase>Plugin.c    - support create/destroy data/key, callbacks,
                       serialize glue (interpreted), instance_to_key/
                       key_to_instance (key members only),
                       get_programs, plugin_new (wiring)
<IDLBase>Plugin.h    - KeyHolder typedef, plugin + support decls
<IDLBase>Support.c   - generics: dds_c_data_TDataWriter/TDataReader/
                       TTypeSupport #include expansion
<IDLBase>Support.h   - DDS_TYPESUPPORT_C / DDS_DATAWRITER_..._C /
                       DDS_DATAREADER_C macro invocations

## Names
- C prefix: module chain joined by '_' (testCodeGen_HelloWorld,
  Module1_HelloStruct1); file-scope types unprefixed (HelloStruct1).
- TYPENAME: "Scope::Name" (testCodeGen::HelloWorld).
- DDS type: DDS_Char/DDS_Double/DDS_Long/... (see mapping table).
- Sequence: DDS_SEQUENCE(<P>_Seq, <P>) in .h.
- Union: DDS_Long _d; nested struct <P>_<Type> {...}_u; wrapper.

## EOL model
CRLF for content lines + bare-LF lines (same as Java oracle);
some template lines carry a leading LF.  Reproduce byte patterns.

## Include guards
<IDLBase>_<HASH>_h -- SAME hash for .h/.Plugin/.Support files of an
IDL file; hash is rtiddsgen-internal (deterministic per IDL base).
Carried data-driven per known oracle (53 values captured) with a
documented fallback hash for unknown IDLs (deviation, like Ada).

## Typecode member table (in <Base>.c get_typecode)
static DDS_TypeCode <P>_g_tc_<member>_... (string members get their
own static DDS_INITIALIZE_STRING_TYPECODE(((BOUND)))); members table
entries: (char*)"name", {rep_id, is_ptr, bitfield, NULL}, ignored,
key (RTI_CDR_REQUIRED_MEMBER / RTI_CDR_KEY_MEMBER),
DDS_PUBLIC_MEMBER, RTICdrTypeCodeAnnotations_INITIALIZER.
Struct TC: DDS_TK_STRUCT, name, member count, members, VM_NONE...
Annotations: _defaultValue/_minValue/_maxValue per kind
(RTI_XCDR_TK_STRING with "" / DOUBLE with 0.0, MIN, MAX ...).
XTypes mask constant 0x0000018C everywhere.

## initialize_w_params (strings):
if allocate_memory: DDS_String_alloc(((BOUND))); copyStringEx("" ...);
else: if != NULL copy...; null-check pattern per member.
copy(): RTICdrType_copyStringEx(&dst->n, src->n, ((BOUND))+1, RTI_FALSE)
        RTICdrType_copyDouble(&dst->n, &src->n) etc.

## Key handling
@key member -> RTI_CDR_KEY_MEMBER in the member table (non-key ->
RTI_CDR_REQUIRED_MEMBER).  Plugin instance_to_key/key_to_instance
copy ONLY the key members via RTICdrType_copy*.  KeyHolder typedef =
the struct itself.

## Consts
#define NAME (value) - int values get L suffix (256L); expressions
parenthesized; module-scope consts prefixed Module1_....

## Enums
typedef enum <P>_<Name> { Members , } <P>_<Name>;  (note 'Var1 , '
trailing space); full struct-like treatment in .c.

## Complete primitive table (from PrimitiveType.c)
DDS type      TC ref           annotations default/min/max
char          DDS_g_tc_char    char=0 (TK_CHAR)
wchar         DDS_g_tc_wchar   TK_WCHAR
octet         DDS_g_tc_octet   0 / RTIXCdrOctet_MIN/MAX
short         DDS_g_tc_short   0 / RTIXCdrShort_MIN/MAX
ushort        DDS_g_tc_ushort  0u / RTIXCdrUnsignedShort_MIN/MAX
long          DDS_g_tc_long    0 / RTIXCdrLong_MIN/MAX
ulong         DDS_g_tc_ulong   0u / RTIXCdrUnsignedLong_MIN/MAX
longlong      DDS_g_tc_longlong 0ll / RTIXCdrLongLong_MIN/MAX
ulonglong     DDS_g_tc_ulonglong 0ull / RTIXCdrUnsignedLongLong_MIN/MAX
float         DDS_g_tc_float   0.0f / RTIXCdrFloat_MIN/MAX
double        DDS_g_tc_double  0.0 / RTIXCdrDouble_MIN/MAX
longdouble    DDS_g_tc_longdouble (no annotation lines)
boolean       DDS_g_tc_boolean TK_BOOLEAN (FALSE only)
string        (own TC static)  TK_STRING "" (no min/max)
TK kind: TK_CHAR/TK_WCHAR/TK_OCTET/TK_SHORT/TK_USHORT/TK_LONG/
TK_ULONG/TK_LONGLONG/TK_ULONGLONG/TK_FLOAT/TK_DOUBLE/TK_STRING/
TK_BOOLEAN.

## String bounds
Bounded:  ((BOUND)) everywhere (alloc/copy/copy bound+1).
Unbounded: (255L) (alloc, copy (255L) + 1).
