
/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from Demo.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#include "DemoSupport.h"
#include "DemoPlugin.h"

/* ========================================================================= */
/**
<<IMPLEMENTATION>>

Defines:   TData,
TDataWriter,
TDataReader,
TTypeSupport

Configure and implement 'com_saabgroup_enterprisebus_idldemo_MyStruct' support classes.

Note: Only the #defined classes get defined
*/

/* ----------------------------------------------------------------- */
/* DDSDataWriter
*/

/**
<<IMPLEMENTATION >>

Defines:   TDataWriter, TData
*/

/* Requires */
#define TTYPENAME   com_saabgroup_enterprisebus_idldemo_MyStructTYPENAME

/* Defines */
#define TDataWriter com_saabgroup_enterprisebus_idldemo_MyStructDataWriter
#define TData       com_saabgroup_enterprisebus_idldemo_MyStruct

#define RTI_ENABLE_TDATAWRITER_DATA_CONSTRUCTOR_METHODS
#include "dds_c/generic/dds_c_data_TDataWriter.gen"
#undef RTI_ENABLE_TDATAWRITER_DATA_CONSTRUCTOR_METHODS

#undef TDataWriter
#undef TData

#undef TTYPENAME

/* ----------------------------------------------------------------- */
/* DDSDataReader
*/

/**
<<IMPLEMENTATION >>

Defines:   TDataReader, TDataSeq, TData
*/

/* Requires */
#define TTYPENAME   com_saabgroup_enterprisebus_idldemo_MyStructTYPENAME

/* Defines */
#define TDataReader com_saabgroup_enterprisebus_idldemo_MyStructDataReader
#define TDataSeq    com_saabgroup_enterprisebus_idldemo_MyStructSeq
#define TData       com_saabgroup_enterprisebus_idldemo_MyStruct

#define RTI_ENABLE_TDATAREADER_DATA_CONSISTENCY_CHECK_METHOD
#include "dds_c/generic/dds_c_data_TDataReader.gen"
#undef RTI_ENABLE_TDATAREADER_DATA_CONSISTENCY_CHECK_METHOD

#undef TDataReader
#undef TDataSeq
#undef TData

#undef TTYPENAME

/* ----------------------------------------------------------------- */
/* TypeSupport

<<IMPLEMENTATION >>

Requires:  TTYPENAME,
TPlugin_new
TPlugin_delete
Defines:   TTypeSupport, TData, TDataReader, TDataWriter
*/

/* Requires */
#define TTYPENAME    com_saabgroup_enterprisebus_idldemo_MyStructTYPENAME
#define TPlugin_new  com_saabgroup_enterprisebus_idldemo_MyStructPlugin_new
#define TPlugin_delete  com_saabgroup_enterprisebus_idldemo_MyStructPlugin_delete

/* Defines */
#define TTypeSupport com_saabgroup_enterprisebus_idldemo_MyStructTypeSupport
#define TData        com_saabgroup_enterprisebus_idldemo_MyStruct
#define TDataReader  com_saabgroup_enterprisebus_idldemo_MyStructDataReader
#define TDataWriter  com_saabgroup_enterprisebus_idldemo_MyStructDataWriter
#define TGENERATE_SER_CODE
#ifndef NDDS_STANDALONE_TYPE
#define TGENERATE_TYPECODE
#endif

#include "dds_c/generic/dds_c_data_TTypeSupport.gen"

#undef TTypeSupport
#undef TData
#undef TDataReader
#undef TDataWriter
#ifndef NDDS_STANDALONE_TYPE
#undef TGENERATE_TYPECODE
#endif
#undef TGENERATE_SER_CODE
#undef TTYPENAME
#undef TPlugin_new
#undef TPlugin_delete

/* ========================================================================= */
/**
<<IMPLEMENTATION>>

Defines:   TData,
TDataWriter,
TDataReader,
TTypeSupport

Configure and implement 'com_saabgroup_enterprisebus_idldemo_Demo' support classes.

Note: Only the #defined classes get defined
*/

/* ----------------------------------------------------------------- */
/* DDSDataWriter
*/

/**
<<IMPLEMENTATION >>

Defines:   TDataWriter, TData
*/

/* Requires */
#define TTYPENAME   com_saabgroup_enterprisebus_idldemo_DemoTYPENAME

/* Defines */
#define TDataWriter com_saabgroup_enterprisebus_idldemo_DemoDataWriter
#define TData       com_saabgroup_enterprisebus_idldemo_Demo

#define RTI_ENABLE_TDATAWRITER_DATA_CONSTRUCTOR_METHODS
#include "dds_c/generic/dds_c_data_TDataWriter.gen"
#undef RTI_ENABLE_TDATAWRITER_DATA_CONSTRUCTOR_METHODS

#undef TDataWriter
#undef TData

#undef TTYPENAME

/* ----------------------------------------------------------------- */
/* DDSDataReader
*/

/**
<<IMPLEMENTATION >>

Defines:   TDataReader, TDataSeq, TData
*/

/* Requires */
#define TTYPENAME   com_saabgroup_enterprisebus_idldemo_DemoTYPENAME

/* Defines */
#define TDataReader com_saabgroup_enterprisebus_idldemo_DemoDataReader
#define TDataSeq    com_saabgroup_enterprisebus_idldemo_DemoSeq
#define TData       com_saabgroup_enterprisebus_idldemo_Demo

#define RTI_ENABLE_TDATAREADER_DATA_CONSISTENCY_CHECK_METHOD
#include "dds_c/generic/dds_c_data_TDataReader.gen"
#undef RTI_ENABLE_TDATAREADER_DATA_CONSISTENCY_CHECK_METHOD

#undef TDataReader
#undef TDataSeq
#undef TData

#undef TTYPENAME

/* ----------------------------------------------------------------- */
/* TypeSupport

<<IMPLEMENTATION >>

Requires:  TTYPENAME,
TPlugin_new
TPlugin_delete
Defines:   TTypeSupport, TData, TDataReader, TDataWriter
*/

/* Requires */
#define TTYPENAME    com_saabgroup_enterprisebus_idldemo_DemoTYPENAME
#define TPlugin_new  com_saabgroup_enterprisebus_idldemo_DemoPlugin_new
#define TPlugin_delete  com_saabgroup_enterprisebus_idldemo_DemoPlugin_delete

/* Defines */
#define TTypeSupport com_saabgroup_enterprisebus_idldemo_DemoTypeSupport
#define TData        com_saabgroup_enterprisebus_idldemo_Demo
#define TDataReader  com_saabgroup_enterprisebus_idldemo_DemoDataReader
#define TDataWriter  com_saabgroup_enterprisebus_idldemo_DemoDataWriter
#define TGENERATE_SER_CODE
#ifndef NDDS_STANDALONE_TYPE
#define TGENERATE_TYPECODE
#endif

#include "dds_c/generic/dds_c_data_TTypeSupport.gen"

#undef TTypeSupport
#undef TData
#undef TDataReader
#undef TDataWriter
#ifndef NDDS_STANDALONE_TYPE
#undef TGENERATE_TYPECODE
#endif
#undef TGENERATE_SER_CODE
#undef TTYPENAME
#undef TPlugin_new
#undef TPlugin_delete

