
/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from sequences.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#include "sequencesSupport.h"
#include "sequencesPlugin.h"

/* ========================================================================= */
/**
<<IMPLEMENTATION>>

Defines:   TData,
TDataWriter,
TDataReader,
TTypeSupport

Configure and implement 'com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key' support classes.

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
#define TTYPENAME   com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyTYPENAME

/* Defines */
#define TDataWriter com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyDataWriter
#define TData       com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key

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
#define TTYPENAME   com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyTYPENAME

/* Defines */
#define TDataReader com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyDataReader
#define TDataSeq    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeySeq
#define TData       com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key

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
#define TTYPENAME    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyTYPENAME
#define TPlugin_new  com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_new
#define TPlugin_delete  com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyPlugin_delete

/* Defines */
#define TTypeSupport com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyTypeSupport
#define TData        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_Key
#define TDataReader  com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyDataReader
#define TDataWriter  com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_KeyDataWriter
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

Configure and implement 'com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList' support classes.

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
#define TTYPENAME   com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListTYPENAME

/* Defines */
#define TDataWriter com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListDataWriter
#define TData       com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList

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
#define TTYPENAME   com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListTYPENAME

/* Defines */
#define TDataReader com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListDataReader
#define TDataSeq    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListSeq
#define TData       com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList

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
#define TTYPENAME    com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListTYPENAME
#define TPlugin_new  com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_new
#define TPlugin_delete  com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListPlugin_delete

/* Defines */
#define TTypeSupport com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListTypeSupport
#define TData        com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatList
#define TDataReader  com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListDataReader
#define TDataWriter  com_rti_tests_DdsTopics_EngagementControl_ZonedThreatList_ZonedThreatListDataWriter
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

