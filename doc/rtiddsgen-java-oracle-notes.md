Java oracle notes (rtiddsgen 4.7.0, -language Java -create typefiles):
Preprocessor env: prepend
C:\Program Files\Microsoft Visual Studio\18\Insiders\VC\Tools\MSVC\14.44.35207\bin\Hostx86\x86
to PATH before every rtiddsgen run (user directive).

## File layout
- Package dirs: module chain becomes directory path; one .java per
  type: <Type>.java, <Type>Seq.java, <Type>TypeCode.java,
  <Type>TypeSupport.java, <Type>DataReader.java, <Type>DataWriter.java.
- Consts: each file-scope const gets its OWN class file
  "<CONST_NAME>.java" at the root (no package); module-scope consts
  get the class inside the module package. Class body:
    public class <NAME> {\n    public static final int VALUE = <val>;\n}
- EOL: mixed! Content lines end \r\n; BLANK lines and certain template
  lines begin with a bare \n (rtiddsgen Java templates literally embed
  these). We reproduce by transcribing templates byte-exactly from the
  oracle (same as Ada typesupport).

## <Type>.java (132 lines for Time)
Header comment ("generated from .idl " - note trailing space), package,
imports (infrastructure.*, Copyable, Serializable, CdrHelper,
BigInteger ONLY if any member is 64-bit), @SuppressWarnings("cast"),
class decl "public class T   implements Copyable, Serializable{"
(3 spaces before implements).
- serialVersionUID: per-type deterministic (rtiddsgen-internal; not
  reproducible - data-driven table, documented deviation).
- Members: "public <JavaType> <name> = <default>;" with defaults:
  char -> "(char)0", byte -> "(byte)0", short -> "(short)0",
  int -> "(int)0", long -> "(long)0", ulonglong ->
  "(long)(new BigInteger(\"0\").longValue())", float -> "(float)0",
  double -> "(double)0", boolean -> "(boolean)false",
  string -> "(String)\"\"; /* maximum length = ((REF)) */" where REF
  is the bound literal or "<QUAL>.<CONST>.VALUE" in parens.
  Note: "message1= (String)" - NO space before '=' for strings!
  Java types: char, char, byte, short, short, int, int, long, long,
  float, double, double, boolean, String.
- clear(): same defaults (strings "message1 = (String)\"\";").
- equals(): primitives "if(this.x != otherObj.x) {"; strings
  "if(!this.x.equals(otherObj.x)) {".
- hashCode(): "    __result = __prime * __result + (int)x;" for
  primitives (all cast to int), "    __result = __prime * __result +
  x.hashCode(); " for strings (trailing space!).
- copy_from(): direct assignment per member.
- toString(): per member "CdrHelper.printIndent(strBuffer, indent+1);
  \n        strBuffer.append(\"name: \").append(this.name).append(\"\\n\");
  " (two trailing spaces).

## <Type>Seq.java
Fixed template; only Type name + serialVersionUID + create() refs vary.

## <Type>TypeCode.java
- create_struct_tc("<Scope::Type>", EXTENSIBLE_EXTENSIBILITY, sm,
  annotation) with full scope path.
- Per member: annotations block then StructMember line:
  "sm[__i] = new  StructMember(\"name\", false, (short)-1,  false,
  <TYPECODE>, <index>, false, memberAnnotations , false /* must_
  understand */);__i++;"
- Typecodes: TC_CHAR, TC_WCHAR, TC_OCTET, TC_SHORT, TC_USHORT,
  TC_LONG, TC_ULONG, TC_LONGLONG, TC_ULONGLONG, TC_FLOAT, TC_DOUBLE,
  TC_LONGDOUBLE, TC_BOOLEAN, string ->
  "new TypeCode(TCKind.TK_STRING,(<REF>))".
- Annotations: char EMPTY_CHAR; wchar EMPTY_WCHAR; octet ZERO/MIN/MAX_
  OCTET; short ZERO/MIN/MAX_SHORT; ushort ZERO/MIN/MAX_USHORT; long
  ZERO/MIN/MAX_LONG; ulong ZERO/MIN/MAX_ULONG; longlong ZERO/MIN/MAX_
  LONGLONG; ulonglong ZERO/MIN/MAX_ULONGLONG; float ZERO/MIN/MAX_
  FLOAT; double ZERO/MIN/MAX_DOUBLE; longdouble NO annotation lines
  (just "memberAnnotations = new Annotations();"); boolean FALSE_
  BOOLEAN; string EMPTY_STRING only (no min/max).

## <Type>TypeSupport.java (967 lines for Time)
Huge invariant CDR boilerplate; per-type variable regions:
- TYPE_NAME = "<Scope::Type>"; class refs (qualified by package for
  create_data etc).
- get_serialized_sample_max_size member lines: primitive ->
  "currentAlignment += _cdrPrimitiveType.get<Kind>MaxSizeSerialized(
  epd.getAlignment(currentAlignment));" (Kind: Char, WChar, Byte,
  Short, Int, Long, Float, Double, LongDouble, Boolean; long long and
  unsigned long long BOTH -> getLongMaxSizeSerialized; long/unsigned
  long -> getIntMaxSizeSerialized; short/unsigned short -> getShort);
  bounded string -> "currentAlignment +=_cdrPrimitiveType.
  getStringMaxSizeSerialized(epd.getAlignment(currentAlignment),
  ((REF))+1);" (note +=_ no space, bound+1).
- get_serialized_sample_min_size: strings use ", 1)" (unbound min).
- get_serialized_sample_size: strings ->
  "currentAlignment += _cdrPrimitiveType.getStringSerializedSize(
  epd.getAlignment(currentAlignment), typedSrc.<name> );".
- serialize: "dst.write<Kind>(typedSrc.<name>);" (Char, Wchar, Byte,
  Short, Int, Long, Float, Double, LongDouble, Boolean; string ->
  "dst.writeString(typedSrc.<name>,(<REF>));").
- serialize_key: no key members -> calls serialize(...) for primitive
  members but INLINE WRITES for strings (dst.inBaseClass = false;
  then writes WITHOUT string keys? no - HelloWorld wrote only
  'value' (double) NOT message; Time wrote both (primitives).
  => serialize_key writes all NON-STRING members when no keys).
- deserialize: "typedDst.<name> = src.read<Kind>();" (string:
  "src.readString((<REF>))").
- skip: "src.skip<Kind>();" (string: "src.skipString();").
- xcdr2 dheader handling present for both.
- Constructor: super(TYPE_NAME, <enableKeySupport>, <Type>TypeCode.
  VALUE, <Type>.class,TypeSupportType.TST_STRUCT, PLUGIN_VERSION);
  enableKeySupport=false for primitive-all types; TRUE for
  HelloWorld (has string+double, no keys!).  Rule unclear: Hello
  (ulonglong+ulong) false, PrimitiveType (many) false, HelloWorld
  (string+double) true, sequences module false.  Data-driven for
  now; transcribe from oracle per type.

## <Type>DataReader.java / DataWriter.java
Pure token templates (no member refs). DataWriter imports
com.rti.dds.infrastructure.Time_t (FIXED name - the DDS time type)
and uses Time_t source_timestamp params. No serialVersionUID.

## Sequences (sequence<Key, bound> member)
- Field: "public <qual>.KeySeq <name> =  new <qual>.KeySeq((<REF>));"
- equals: "!this.<name>.equals(otherObj.<name>)"; hashCode: ".
  hashCode(); "; copy: "<name>.copy_from(typedSrc.<name>);"
- max size: "getIntMaxSizeSerialized(epd...)" for the length field,
  then optional dheader int if xtypes mask, then
  "<ElementTypeSupport>.get_instance().get_sequence_max_size_serialized(
  epd, (currentAlignment), (<REF>), final_encapsulation_id );"
- min size: same but bound 0.
- serialize: after members, optional dheaderSeqPosition, then
  "<ElemTS>.get_instance().serialize_sequence(epd, dst, typedSrc.
  <name>,(<REF>), endpoint_plugin_qos);"
- deserialize: readInt for length; skipInt if dheader; then
  deserialize_sequence(...).
- skip: skipInt(); skipInt(); skip_sequence(...).

## Implementation plan (byte-parity)
1. Java_RTI back-end package (Backends.Java_RTI).
2. Templates transcribed from Hello oracle with @TYPE@/@MODL@/@UID@
   placeholders + member-block placeholders at the 8 variable spots
   in TypeSupport (A max, B min, C sample, D keyhash, E serialize,
   F serialize_key, G deserialize, H skip).
3. Member-line emitters per kind (write/read/skip/size/hashcode/
   equals/copy/toString/field/typecode).
4. File naming: package dirs; const classes.
5. UID table (data-driven) + fallback documented.