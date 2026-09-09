
/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from ArrayRanges.idl
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef ArrayRangesSupport_237584959_h
#define ArrayRangesSupport_237584959_h

/* Uses */
#include "ArrayRanges.h"

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

    DDS_TYPESUPPORT_C(hello_World_TTypeSupport, hello_World_T);
    DDS_DATAWRITER_WITH_DATA_CONSTRUCTOR_METHODS_C(hello_World_TDataWriter, hello_World_T);
    DDS_DATAREADER_C(hello_World_TDataReader, hello_World_TSeq, hello_World_T);

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

    DDS_TYPESUPPORT_C(hello_HelloWorldTypeSupport, hello_HelloWorld);
    DDS_DATAWRITER_WITH_DATA_CONSTRUCTOR_METHODS_C(hello_HelloWorldDataWriter, hello_HelloWorld);
    DDS_DATAREADER_C(hello_HelloWorldDataReader, hello_HelloWorldSeq, hello_HelloWorld);

    #if defined(NDDS_USER_DLL_EXPORT) || defined(NDDS_USER_SYMBOL_EXPORT)
    #undef NDDSUSERDllExport
    #define NDDSUSERDllExport
    #endif

    #ifdef __cplusplus
}
#endif

#endif  /* ArrayRangesSupport_237584959_h */
