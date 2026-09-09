

/*
WARNING: THIS FILE IS AUTO-GENERATED. DO NOT MODIFY.

This file was generated from ArrayRanges.idl 
using RTI Code Generator (rtiddsgen) version 4.7.0.
The rtiddsgen tool is part of the RTI Connext DDS distribution.
For more information, type 'rtiddsgen -help' at a command shell
or consult the Code Generator User's Manual.
*/

#ifndef NDDS_STANDALONE_TYPE
#ifndef ndds_c_h
#include "ndds/ndds_c.h"
#endif

#ifndef dds_c_log_infrastructure_h
#include "dds_c/dds_c_infrastructure_impl.h"       
#endif 

#ifndef cdr_type_h
#include "cdr/cdr_type.h"
#endif    

#include "osapi/osapi_atomic.h"
#else
#include "ndds_standalone_type.h"
#endif

#include "ArrayRanges.h"

#ifndef NDDS_STANDALONE_TYPE
#include "ArrayRangesPlugin.h"
#endif

/* ========================================================================= */
const char *hello_World_TTYPENAME = "hello::World_T";

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * hello_World_T_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode_Member hello_World_T_g_tc_members[1]=
    {

        {
            (char *)"data",/* Member name */
            {
                0,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            RTI_CDR_REQUIRED_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }
    };

    static DDS_TypeCode hello_World_T_g_tc =
    {{
            DDS_TK_STRUCT, /* Kind */
            DDS_BOOLEAN_FALSE, /* Ignored */
            -1, /*Ignored*/
            (char *)"hello::World_T", /* Name */
            NULL, /* Ignored */ 
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            1, /* Number of members */
            hello_World_T_g_tc_members, /* Members */
            DDS_VM_NONE, /* Ignored */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for hello_World_T*/

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &hello_World_T_g_tc;
    }

    hello_World_T_g_tc._data._annotations._allowedDataRepresentationMask = 5;

    hello_World_T_g_tc_members[0]._representation._typeCode =  (RTICdrTypeCode *)&DDS_g_tc_long;

    /* Initialize the values for member annotations. */
    hello_World_T_g_tc_members[0]._annotations._defaultValue._d = RTI_XCDR_TK_LONG;
    hello_World_T_g_tc_members[0]._annotations._defaultValue._u.long_value = 0;
    hello_World_T_g_tc_members[0]._annotations._minValue._d = RTI_XCDR_TK_LONG;
    hello_World_T_g_tc_members[0]._annotations._minValue._u.long_value = RTIXCdrLong_MIN;
    hello_World_T_g_tc_members[0]._annotations._maxValue._d = RTI_XCDR_TK_LONG;
    hello_World_T_g_tc_members[0]._annotations._maxValue._u.long_value = RTIXCdrLong_MAX;

    hello_World_T_g_tc._data._sampleAccessInfo =
    hello_World_T_get_sample_access_info();
    hello_World_T_g_tc._data._typePlugin =
    hello_World_T_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &hello_World_T_g_tc;
}

RTIXCdrSampleAccessInfo *hello_World_T_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo hello_World_T_g_memberAccessInfos[1] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo hello_World_T_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &hello_World_T_g_sampleAccessInfo;
    }

    hello_World_T_g_memberAccessInfos[0].bindingMemberValueOffset[0] =
    offsetof(struct hello_World_T, data);

    hello_World_T_g_sampleAccessInfo.memberAccessInfos =
    hello_World_T_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(hello_World_T);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            hello_World_T_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            hello_World_T_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    hello_World_T_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &hello_World_T_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *hello_World_T_get_type_plugin_info()
{
    static RTIXCdrTypePlugin hello_World_T_g_typePlugin =
    {
        NULL, /* serialize */
        NULL, /* serialize_key */
        NULL, /* deserialize_sample */
        NULL, /* deserialize_key_sample */
        NULL, /* skip */
        NULL, /* get_serialized_sample_size */
        NULL, /* get_serialized_sample_max_size_ex */
        NULL, /* get_serialized_key_max_size_ex */
        NULL, /* get_serialized_sample_min_size */
        NULL, /* serialized_sample_to_key */
        (RTIXCdrTypePluginInitializeSampleFunction)
        hello_World_T_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        hello_World_T_finalize_w_return,
        NULL,
        NULL
    };

    return &hello_World_T_g_typePlugin;
}
#endif

RTIBool hello_World_T_initialize(
    hello_World_T* sample)
{
    return hello_World_T_initialize_ex(
        sample, 
        RTI_TRUE, 
        RTI_TRUE);
}
RTIBool hello_World_T_initialize_w_params(
    hello_World_T *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }

    sample->data = 0;

    return RTI_TRUE;
}
RTIBool hello_World_T_initialize_ex(
    hello_World_T *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return hello_World_T_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool hello_World_T_finalize_w_return(
    hello_World_T* sample)
{
    hello_World_T_finalize_ex(sample, RTI_TRUE);

    return RTI_TRUE;
}

void hello_World_T_finalize(
    hello_World_T* sample)
{  
    hello_World_T_finalize_ex(
        sample, 
        RTI_TRUE);
}

void hello_World_T_finalize_ex(
    hello_World_T *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    hello_World_T_finalize_w_params(
        sample,
        &deallocParams);
}

void hello_World_T_finalize_w_params(
    hello_World_T *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

}

void hello_World_T_finalize_optional_members(
    hello_World_T* sample, RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParamsTmp =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;
    struct DDS_TypeDeallocationParams_t * deallocParams =
    &deallocParamsTmp;

    if (sample==NULL) {
        return;
    } 
    RTIOsapiUtility_unusedParameter(deallocParams);

    deallocParamsTmp.delete_pointers = (DDS_Boolean)deletePointers;
    deallocParamsTmp.delete_optional_members = DDS_BOOLEAN_TRUE;

}

RTIBool hello_World_T_copy(
    hello_World_T* dst,
    const hello_World_T* src)
{

    if (dst == NULL || src == NULL) {
        return RTI_FALSE;
    }

    if (!RTICdrType_copyLong (
        &dst->data, 
        &src->data)) { 
        return RTI_FALSE;
    }

    return RTI_TRUE;
}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'hello_World_T' sequence class.
*/
#define T hello_World_T
#define TSeq hello_World_TSeq

#define T_initialize_w_params hello_World_T_initialize_w_params

#define T_finalize_w_params   hello_World_T_finalize_w_params
#define T_copy       hello_World_T_copy

#ifndef NDDS_STANDALONE_TYPE
#include "dds_c/generic/dds_c_sequence_TSeq.gen"
#else
#include "dds_c_sequence_TSeq.gen"
#endif

#undef T_copy
#undef T_finalize_w_params

#undef T_initialize_w_params

#undef TSeq
#undef T

/* ========================================================================= */
const char *hello_HelloWorldTYPENAME = "hello::HelloWorld";

#ifndef NDDS_STANDALONE_TYPE

DDS_TypeCode * hello_HelloWorld_get_typecode(void)
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static DDS_TypeCode hello_HelloWorld_g_tc_msg_string = DDS_INITIALIZE_STRING_TYPECODE((128L));
    static DDS_TypeCode hello_HelloWorld_g_tc_worlds_1_array =DDS_INITIALIZE_ARRAY_TYPECODE(1,(hello_SIZE), NULL,NULL);
    static DDS_TypeCode hello_HelloWorld_g_tc_worlds_2_array =DDS_INITIALIZE_ARRAY_TYPECODE(1,24L, NULL,NULL);
    static DDS_TypeCode hello_HelloWorld_g_tc_profile_1_array =DDS_INITIALIZE_ARRAY_TYPECODE(1,24L, NULL,NULL);
    static DDS_TypeCode hello_HelloWorld_g_tc_profile_2_array =DDS_INITIALIZE_ARRAY_TYPECODE(1,(hello_SIZE), NULL,NULL);

    static DDS_TypeCode_Member hello_HelloWorld_g_tc_members[5]=
    {

        {
            (char *)"msg",/* Member name */
            {
                0,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            RTI_CDR_REQUIRED_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }, 
        {
            (char *)"worlds_1",/* Member name */
            {
                1,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            RTI_CDR_REQUIRED_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }, 
        {
            (char *)"worlds_2",/* Member name */
            {
                2,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            RTI_CDR_REQUIRED_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }, 
        {
            (char *)"profile_1",/* Member name */
            {
                3,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            RTI_CDR_REQUIRED_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }, 
        {
            (char *)"profile_2",/* Member name */
            {
                4,/* Representation ID */
                DDS_BOOLEAN_FALSE,/* Is a pointer? */
                -1, /* Bitfield bits */
                NULL/* Member type code is assigned later */
            },
            0, /* Ignored */
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            RTI_CDR_REQUIRED_MEMBER, /* Is a key? */
            DDS_PUBLIC_MEMBER,/* Member visibility */
            RTICdrTypeCodeAnnotations_INITIALIZER
        }
    };

    static DDS_TypeCode hello_HelloWorld_g_tc =
    {{
            DDS_TK_STRUCT, /* Kind */
            DDS_BOOLEAN_FALSE, /* Ignored */
            -1, /*Ignored*/
            (char *)"hello::HelloWorld", /* Name */
            NULL, /* Ignored */ 
            0, /* Ignored */
            0, /* Ignored */
            NULL, /* Ignored */
            5, /* Number of members */
            hello_HelloWorld_g_tc_members, /* Members */
            DDS_VM_NONE, /* Ignored */
            RTICdrTypeCodeAnnotations_INITIALIZER,
            DDS_BOOLEAN_TRUE, /* _isCopyable */
            NULL, /* _sampleAccessInfo: assigned later */
            NULL /* _typePlugin: assigned later */
        }}; /* Type code for hello_HelloWorld*/

    if (RTIOsapiAtomic_load32(&is_initialized, RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return &hello_HelloWorld_g_tc;
    }

    hello_HelloWorld_g_tc._data._annotations._allowedDataRepresentationMask = 5;

    hello_HelloWorld_g_tc_worlds_1_array._data._typeCode =(RTICdrTypeCode *)hello_World_T_get_typecode();
    hello_HelloWorld_g_tc_worlds_2_array._data._typeCode =(RTICdrTypeCode *)hello_World_T_get_typecode();
    hello_HelloWorld_g_tc_profile_1_array._data._typeCode =(RTICdrTypeCode *)&DDS_g_tc_boolean;
    hello_HelloWorld_g_tc_profile_2_array._data._typeCode =(RTICdrTypeCode *)&DDS_g_tc_boolean;
    hello_HelloWorld_g_tc_members[0]._representation._typeCode =  (RTICdrTypeCode *)&hello_HelloWorld_g_tc_msg_string;
    hello_HelloWorld_g_tc_members[1]._representation._typeCode =  (RTICdrTypeCode *)& hello_HelloWorld_g_tc_worlds_1_array;
    hello_HelloWorld_g_tc_members[2]._representation._typeCode =  (RTICdrTypeCode *)& hello_HelloWorld_g_tc_worlds_2_array;
    hello_HelloWorld_g_tc_members[3]._representation._typeCode =  (RTICdrTypeCode *)& hello_HelloWorld_g_tc_profile_1_array;
    hello_HelloWorld_g_tc_members[4]._representation._typeCode =  (RTICdrTypeCode *)& hello_HelloWorld_g_tc_profile_2_array;

    /* Initialize the values for member annotations. */
    hello_HelloWorld_g_tc_members[0]._annotations._defaultValue._d = RTI_XCDR_TK_STRING;
    hello_HelloWorld_g_tc_members[0]._annotations._defaultValue._u.string_value = (DDS_Char *) "";

    hello_HelloWorld_g_tc._data._sampleAccessInfo =
    hello_HelloWorld_get_sample_access_info();
    hello_HelloWorld_g_tc._data._typePlugin =
    hello_HelloWorld_get_type_plugin_info();

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);

    return &hello_HelloWorld_g_tc;
}

RTIXCdrSampleAccessInfo *hello_HelloWorld_get_sample_access_info()
{
    static RTI_ATOMIC(RTIBool) is_initialized;

    static RTIXCdrMemberAccessInfo hello_HelloWorld_g_memberAccessInfos[5] =
    {RTIXCdrMemberAccessInfo_INITIALIZER};

    static RTIXCdrSampleAccessInfo hello_HelloWorld_g_sampleAccessInfo =
    RTIXCdrSampleAccessInfo_INITIALIZER;

    if (RTIOsapiAtomic_load32(
        &is_initialized,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_ACQUIRE)) {
        return (RTIXCdrSampleAccessInfo*) &hello_HelloWorld_g_sampleAccessInfo;
    }

    hello_HelloWorld_g_memberAccessInfos[0].bindingMemberValueOffset[0] =
    offsetof(struct hello_HelloWorld, msg);

    hello_HelloWorld_g_memberAccessInfos[1].bindingMemberValueOffset[0] =
    offsetof(struct hello_HelloWorld, worlds_1);

    hello_HelloWorld_g_memberAccessInfos[2].bindingMemberValueOffset[0] =
    offsetof(struct hello_HelloWorld, worlds_2);

    hello_HelloWorld_g_memberAccessInfos[3].bindingMemberValueOffset[0] =
    offsetof(struct hello_HelloWorld, profile_1);

    hello_HelloWorld_g_memberAccessInfos[4].bindingMemberValueOffset[0] =
    offsetof(struct hello_HelloWorld, profile_2);

    hello_HelloWorld_g_sampleAccessInfo.memberAccessInfos =
    hello_HelloWorld_g_memberAccessInfos;

    {
        size_t candidateTypeSize = sizeof(hello_HelloWorld);

        if (candidateTypeSize > RTIXCdrLong_MAX) {
            hello_HelloWorld_g_sampleAccessInfo.typeSize[0] =
            RTIXCdrLong_MAX;
        } else {
            hello_HelloWorld_g_sampleAccessInfo.typeSize[0] =
            (RTIXCdrUnsignedLong) candidateTypeSize;
        }
    }

    hello_HelloWorld_g_sampleAccessInfo.languageBinding =
    RTI_XCDR_TYPE_BINDING_C ;

    RTIOsapiAtomic_store32(
        &is_initialized,
        RTI_TRUE,
        RTI_OSAPI_ATOMIC_MEMORY_ORDER_RELEASE);
    return (RTIXCdrSampleAccessInfo*) &hello_HelloWorld_g_sampleAccessInfo;
}
RTIXCdrTypePlugin *hello_HelloWorld_get_type_plugin_info()
{
    static RTIXCdrTypePlugin hello_HelloWorld_g_typePlugin =
    {
        NULL, /* serialize */
        NULL, /* serialize_key */
        NULL, /* deserialize_sample */
        NULL, /* deserialize_key_sample */
        NULL, /* skip */
        NULL, /* get_serialized_sample_size */
        NULL, /* get_serialized_sample_max_size_ex */
        NULL, /* get_serialized_key_max_size_ex */
        NULL, /* get_serialized_sample_min_size */
        NULL, /* serialized_sample_to_key */
        (RTIXCdrTypePluginInitializeSampleFunction)
        hello_HelloWorld_initialize_ex,
        NULL,
        (RTIXCdrTypePluginFinalizeSampleFunction)
        hello_HelloWorld_finalize_w_return,
        NULL,
        NULL
    };

    return &hello_HelloWorld_g_typePlugin;
}
#endif

RTIBool hello_HelloWorld_initialize(
    hello_HelloWorld* sample)
{
    return hello_HelloWorld_initialize_ex(
        sample, 
        RTI_TRUE, 
        RTI_TRUE);
}
RTIBool hello_HelloWorld_initialize_w_params(
    hello_HelloWorld *sample,
    const struct DDS_TypeAllocationParams_t *allocParams)
{

    if (sample == NULL) {
        return RTI_FALSE;
    }
    if (allocParams == NULL) {
        return RTI_FALSE;
    }

    if (allocParams->allocate_memory) {
        sample->msg = DDS_String_alloc((128L));
        if (sample->msg != NULL) {
            RTIOsapiUtility_unusedReturnValue(
                RTICdrType_copyStringEx(
                    &sample->msg,
                    "",
                    (128L),
                    RTI_FALSE),
                    RTIBool);
        }
        if (sample->msg == NULL) {
            return RTI_FALSE;
        }
    } else {
        if (sample->msg != NULL) {
            RTIOsapiUtility_unusedReturnValue(
                RTICdrType_copyStringEx(
                    &sample->msg,
                    "",
                    (128L),
                    RTI_FALSE),
                    RTIBool);
            if (sample->msg == NULL) {
                return RTI_FALSE;
            }
        }
    }

    {
        int i = 0;
        hello_World_T* elem =
        (hello_World_T*) (&sample->worlds_1[0]);

        for (i = 0; i < (int) (((hello_SIZE))); ++i, ++elem) {
            if (!hello_World_T_initialize_w_params(
                elem,
                allocParams)) {
                return RTI_FALSE;
            }
        }
    }
    {
        int i = 0;
        hello_World_T* elem =
        (hello_World_T*) (&sample->worlds_2[0]);

        for (i = 0; i < (int) ((24L)); ++i, ++elem) {
            if (!hello_World_T_initialize_w_params(
                elem,
                allocParams)) {
                return RTI_FALSE;
            }
        }
    }
    RTICdrType_initArrayUnsafe(sample->profile_1,
    (24L),
    RTI_CDR_BOOLEAN_SIZE);
    RTICdrType_initArrayUnsafe(sample->profile_2,
    ((hello_SIZE)),
    RTI_CDR_BOOLEAN_SIZE);
    return RTI_TRUE;
}
RTIBool hello_HelloWorld_initialize_ex(
    hello_HelloWorld *sample,
    RTIBool allocatePointers, 
    RTIBool allocateMemory)
{

    struct DDS_TypeAllocationParams_t allocParams =
    DDS_TYPE_ALLOCATION_PARAMS_DEFAULT;

    allocParams.allocate_pointers =  (DDS_Boolean)allocatePointers;
    allocParams.allocate_memory = (DDS_Boolean)allocateMemory;

    return hello_HelloWorld_initialize_w_params(
        sample,
        &allocParams);
}

RTIBool hello_HelloWorld_finalize_w_return(
    hello_HelloWorld* sample)
{
    hello_HelloWorld_finalize_ex(sample, RTI_TRUE);

    return RTI_TRUE;
}

void hello_HelloWorld_finalize(
    hello_HelloWorld* sample)
{  
    hello_HelloWorld_finalize_ex(
        sample, 
        RTI_TRUE);
}

void hello_HelloWorld_finalize_ex(
    hello_HelloWorld *sample,
    RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParams =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;

    if (sample==NULL) {
        return;
    } 

    deallocParams.delete_pointers = (DDS_Boolean)deletePointers;

    hello_HelloWorld_finalize_w_params(
        sample,
        &deallocParams);
}

void hello_HelloWorld_finalize_w_params(
    hello_HelloWorld *sample,
    const struct DDS_TypeDeallocationParams_t *deallocParams)
{
    if (sample==NULL) {
        return;
    }

    if (deallocParams == NULL) {
        return;
    }

    if (sample->msg != NULL) {
        DDS_String_free(sample->msg);
        sample->msg=NULL;

    }
    {
        int i = 0;
        hello_World_T* elem =
        (hello_World_T*) (&sample->worlds_1[0]);

        for (i = 0; i < (int) (((hello_SIZE))); ++i, ++elem) {
            hello_World_T_finalize_w_params(
                elem, 
                deallocParams);
        }
    }

    {
        int i = 0;
        hello_World_T* elem =
        (hello_World_T*) (&sample->worlds_2[0]);

        for (i = 0; i < (int) ((24L)); ++i, ++elem) {
            hello_World_T_finalize_w_params(
                elem, 
                deallocParams);
        }
    }

}

void hello_HelloWorld_finalize_optional_members(
    hello_HelloWorld* sample, RTIBool deletePointers)
{
    struct DDS_TypeDeallocationParams_t deallocParamsTmp =
    DDS_TYPE_DEALLOCATION_PARAMS_DEFAULT;
    struct DDS_TypeDeallocationParams_t * deallocParams =
    &deallocParamsTmp;

    if (sample==NULL) {
        return;
    } 
    RTIOsapiUtility_unusedParameter(deallocParams);

    deallocParamsTmp.delete_pointers = (DDS_Boolean)deletePointers;
    deallocParamsTmp.delete_optional_members = DDS_BOOLEAN_TRUE;

}

RTIBool hello_HelloWorld_copy(
    hello_HelloWorld* dst,
    const hello_HelloWorld* src)
{

    if (dst == NULL || src == NULL) {
        return RTI_FALSE;
    }

    if (!RTICdrType_copyStringEx (
        &dst->msg
        ,
        src->msg, 
        (128L) + 1,
        RTI_FALSE)){
        return RTI_FALSE;
    }
    {
        int i = 0;
        hello_World_T* elemOut = (hello_World_T*) (&dst->worlds_1[0]);
        const hello_World_T* elemIn = (const hello_World_T*) (&src->worlds_1[0]);
        for (i = 0; i < (int) (((hello_SIZE)));++i, ++elemOut, ++elemIn) {
            if (!hello_World_T_copy(
                elemOut
                ,
                (const hello_World_T*)elemIn)) {
                return RTI_FALSE;
            }
        }
    }
    {
        int i = 0;
        hello_World_T* elemOut = (hello_World_T*) (&dst->worlds_2[0]);
        const hello_World_T* elemIn = (const hello_World_T*) (&src->worlds_2[0]);
        for (i = 0; i < (int) ((24L));++i, ++elemOut, ++elemIn) {
            if (!hello_World_T_copy(
                elemOut
                ,
                (const hello_World_T*)elemIn)) {
                return RTI_FALSE;
            }
        }
    }
    if (!RTICdrType_copyArray(
        dst->profile_1,
        src->profile_1,
        (24L),
        RTI_CDR_BOOLEAN_SIZE)) {
        return RTI_FALSE;
    }
    if (!RTICdrType_copyArray(
        dst->profile_2,
        src->profile_2,
        ((hello_SIZE)),
        RTI_CDR_BOOLEAN_SIZE)) {
        return RTI_FALSE;
    }

    return RTI_TRUE;
}

/**
* <<IMPLEMENTATION>>
*
* Defines:  TSeq, T
*
* Configure and implement 'hello_HelloWorld' sequence class.
*/
#define T hello_HelloWorld
#define TSeq hello_HelloWorldSeq

#define T_initialize_w_params hello_HelloWorld_initialize_w_params

#define T_finalize_w_params   hello_HelloWorld_finalize_w_params
#define T_copy       hello_HelloWorld_copy

#ifndef NDDS_STANDALONE_TYPE
#include "dds_c/generic/dds_c_sequence_TSeq.gen"
#else
#include "dds_c_sequence_TSeq.gen"
#endif

#undef T_copy
#undef T_finalize_w_params

#undef T_initialize_w_params

#undef TSeq
#undef T

