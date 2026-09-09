
/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from Demo.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef DemoSupport_920141085_h
#define DemoSupport_920141085_h

/* Uses */
#include "Demo.h"

#ifndef ndds_c_h
#include "ndds/ndds_c.h"
#endif

#ifdef __cplusplus
extern "C" {
    #endif

    #if (defined(RTI_WIN32) || defined (RTI_WINCE) || defined(RTI_INTIME)) && defined(NDDS_USER_DLL_EXPORT)

    #endif

    /* ========================================================================= */
    /**
    Uses:     T

    Defines:  TTypeSupport, TDataWriter, TDataReader

    Organized using the well-documented "Generics Pattern" for
    implementing generics in C and C++.
    */

    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    DDS_TYPESUPPORT_C(com_saabgroup_enterprisebus_idldemo_MyStructTypeSupport, com_saabgroup_enterprisebus_idldemo_MyStruct);
    DDS_DATAWRITER_WITH_DATA_CONSTRUCTOR_METHODS_C(com_saabgroup_enterprisebus_idldemo_MyStructDataWriter, com_saabgroup_enterprisebus_idldemo_MyStruct);
    DDS_DATAREADER_C(com_saabgroup_enterprisebus_idldemo_MyStructDataReader, com_saabgroup_enterprisebus_idldemo_MyStructSeq, com_saabgroup_enterprisebus_idldemo_MyStruct);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif
    /* ========================================================================= */
    /**
    Uses:     T

    Defines:  TTypeSupport, TDataWriter, TDataReader

    Organized using the well-documented "Generics Pattern" for
    implementing generics in C and C++.
    */

    #if defined(NDDS_USER_DLL_EXPORT) && defined(RTI_WIN32)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __declspec(dllexport)
    #endif

    #if !defined(RTI_WIN32) && defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport __attribute__((visibility("default")))
    #endif

    DDS_TYPESUPPORT_C(com_saabgroup_enterprisebus_idldemo_DemoTypeSupport, com_saabgroup_enterprisebus_idldemo_Demo);
    DDS_DATAWRITER_WITH_DATA_CONSTRUCTOR_METHODS_C(com_saabgroup_enterprisebus_idldemo_DemoDataWriter, com_saabgroup_enterprisebus_idldemo_Demo);
    DDS_DATAREADER_C(com_saabgroup_enterprisebus_idldemo_DemoDataReader, com_saabgroup_enterprisebus_idldemo_DemoSeq, com_saabgroup_enterprisebus_idldemo_Demo);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    #ifdef __cplusplus
}
#endif

#endif  /* DemoSupport_920141085_h */
