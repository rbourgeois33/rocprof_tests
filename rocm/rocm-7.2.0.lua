--[[

    file rocm module

    This module was produced with craypkg-gen 1.3.33

]]--



--[[

    track_compiler_load
    Special load/unload handling for compiler/toolkit module which share the same
    vendor environment. This function determines the loading, or stopping the load
    of toolkit modules based on a possible current compiler module loaded. Funtion
    forces compiler/toolkit module versions to match by stopping the toolkit module
    load if its version doesnt match a currently loaded compiler version.

    param   modName
            string, the name of the module whose load/unload is being controlled
    param   modVersionEnv
            string, name of the version enviornment variable of the module being controlled
    return  -

]]--
function track_compiler_load(modName, modVersionEnv)
    -- check if compiler is loading mismatch version
    if (os.getenv("CRAY_LMOD_AMD_CONTROL_TK_LOAD") or "") == "" then
        if  mode() == "load" and (isloaded(modName)) then
            -- save the compiler version already loaded
            local modVersion = os.getenv(modVersionEnv) or ""
            if modVersion ~= myModuleVersion() then
                -- force compiler (already loaded) to match its version with
                -- the loading toolkit version
                LmodError(
                "This rocm module exists but cannot be loaded as requested: " .. myModuleFullName() ..
                "\n    ROCM module version must match the currently loaded AMD module version.\n" ..
                "\n    Note: Please use explicit module commands when loading a non-default" ..
                "\n    rocm module.\n" ..
                "\n    To load rocm with the currently loaded amd/" .. modVersion .. " module" ..
                "\n    please try:\n" ..
                "          $ module load rocm/" .. modVersion .. "\n"
             )
            end
        end
    end
end



-- reasons to keep module from continuing --



-- track that toolkit and compiler version match
track_compiler_load("amd", "CRAY_AMD_COMPILER_VERSION")
-- clear tracking env var is it exists
unsetenv("CRAY_LMOD_AMD_CONTROL_TK_LOAD")



-- template variables ----------------------------------------------------------
local MOD_LEVEL         = "7.2.0"
local AMD_CURPATH       = "/opt/software/rocm/7.2.0"
local INSTALL_ROOT      = "/opt/cray/pe/"
local PKG_CONFIG_PREFIX = "/usr/lib64"
--------------------------------------------------------------------------------

-- CPE variables
local CPE_PRODUCT_NAME  = "CRAY_ROCM"
local CPE_PKGCONFIG_LIB = "rocm-" .. MOD_LEVEL
local CPE_PKGCONFIG_PATH= PKG_CONFIG_PREFIX .. "/pkgconfig"
-- list of all AMD paths used in this module. Lmod handles modules that add duplicate paths
-- rocm bin (includes compiler & c++ ftn compilers, hipC (all amd compiler bins)...)
local AMD_LIB           = AMD_CURPATH .. "/lib"
local AMD_BIN           = AMD_CURPATH .. "/bin"
local AMD_INCLUDE       = AMD_CURPATH .. "/include"
local AMD_MAN           = AMD_CURPATH .. "/share/man"
-- proformance tools for rocm
local AMD_ROCP_LIB      = AMD_CURPATH .. "/lib/rocprofiler"
local AMD_ROCP_INCLUDE  = AMD_CURPATH .. "/include/rocprofiler"
-- dedugger tool for rocm
local AMD_ROCT_LIB      = AMD_CURPATH .. "/lib/roctracer"
local AMD_ROCT_INCLUDE  = AMD_CURPATH .. "/include/roctracer"
-- heterogeneous-compute interface for Portability (HIP) for rocm
-- want envs to match the compiler which is why hip is set in this rocm module
-- since it can be loaded in different environments
local AMD_HIP_CMAKE     = AMD_CURPATH .. "/lib/cmake/hip"
local AMD_HIP_INCLUDE   = AMD_CURPATH .. "/include/hip"



-- standard Lmod functions --



help ([[
]] .. MOD_LEVEL .. "\n" .. [[
]] .. AMD_CURPATH .. "\n" .. [[
This modulefile defines the system paths and environment
variables needed to use the ROCm Toolkit. The ROCm modulefile
enables ROC Profiler, ROC Tracer, HIP, and ROCr.

This module is required to interface with AMD accelerators for
all programming environments.

To use CPE's AMD environment with amd libraries, load the amd
modulefile. The core "amd" compiler modulefile is required if access
to AMD compatible libraries is necessary.

Mixed compiler modules (such as amd-mixed) do not extend the CPE Lmod
hierarchy and can be loaded with core compilers (such as cce).

===================================================================
To see AMD/]] .. MOD_LEVEL .. [[ release information,
  visit https://rocmdocs.amd.com/en/latest
===================================================================

To make this the default version, execute:
/opt/admin-pe/set_default_craypkg/set_default_rocm_7.2.0

Certain components, files or programs contained within this package or
product are Copyright 2021-2023 Hewlett Packard Enterprise Development LP.

]])

whatis(
"Defines the system paths and environment variables required for the ROCm Toolkit."
)



-- environment modifications --



-- set rocm module environment variables
-- CrayPE uses this to find location of rocm
setenv (    "CRAY_ROCM_DIR",              AMD_CURPATH    )
-- Old duplicate value of CRAY_ROCM_DIR
setenv (    "CRAY_ROCM_PREFIX",           AMD_CURPATH    )
-- rocm version
setenv (    "CRAY_ROCM_VERSION",          MOD_LEVEL      )
-- In discussion: May not need to be in the rocm module (may bring in gpu links)
setenv (    "ROCM_PATH",                  AMD_CURPATH    )
-- Used to override the standard hip dir. ( CrayPE doesnt use this. )
setenv (    "HIP_LIB_PATH",               AMD_LIB        )

-- set linux path environment variables
prepend_path (    "PATH",                 AMD_BIN        )
prepend_path (    "MANPATH",              AMD_MAN        )
-- note, this path changed in ROCM 5.2 according to:
-- https://rocm.docs.amd.com/en/latest/understand/file_reorg.html
-- new path location: /opt/rocm-<version>/lib/cmake/hip/
-- old path location: /opt/rocm-<version>/hip/
prepend_path (    "CMAKE_PREFIX_PATH",    AMD_HIP_CMAKE  )


-- set cray module environment variables (perftools related)
setenv (    "CRAY_ROCM_INCLUDE_OPTS",     "-I" .. AMD_INCLUDE .. " -I" .. AMD_ROCP_INCLUDE .. " -I" .. AMD_ROCT_INCLUDE .. " -D__HIP_PLATFORM_AMD__"    )

-- CRAYPE NOTE: *_POST_LINK_OPTS's value is relevant to the creation of the executable,
-- while the others are run time environment variables. A user may choose to run an
-- application with a different craype-hugepages module than was used at compile and
-- link time. To make most efficient use of available memory, use the smallest huge
-- page size necessary for the application. It enforces the alignment and starting
-- addresses of segments so that there are separate read-execute (text) and read-write
-- (data and bss) segments for all pages. This causes libhugetlbfs to avoid overlapping
-- read-execute text with read-write data/bss on huge pages, which would cause a segment
-- to be both writable and executable.
setenv (    "CRAY_ROCM_POST_LINK_OPTS",   " -L" .. AMD_LIB .. " -L" .. AMD_ROCP_LIB .. " -L" .. AMD_ROCT_LIB .. " -lamdhip64" )

-- LIBRARY_PATH additions
prepend_path (    "LD_LIBRARY_PATH",    AMD_LIB          )
prepend_path (    "LD_LIBRARY_PATH",    AMD_ROCP_LIB     )
prepend_path (    "LD_LIBRARY_PATH",    AMD_ROCT_LIB     )

-- Add CPE path to environment
append_path  (    "PE_PRODUCT_LIST",    CPE_PRODUCT_NAME      )
prepend_path (    "PKG_CONFIG_PATH",    AMD_CURPATH .. '/lib/pkgconfig' )
prepend_path (    "PE_PKGCONFIG_LIBS",  CPE_PKGCONFIG_LIB     )


-- CINES environment tweaks --
local AMD_LIB64         = AMD_CURPATH .. "/lib64"
local AMD_HIP           = AMD_CURPATH .. "/hip"
local AMD_HIP_BIN       = AMD_CURPATH .. "/hip/bin"
local AMD_GCN           = AMD_CURPATH .. "/amdgcn/bitcode"
local AMD_LLVM          = AMD_CURPATH .. "/llvm"
local AMD_LLVM_BIN      = AMD_CURPATH .. "/llvm/bin"
setenv ( "HIP_COMPILER",                      "clang" )
setenv ( "HIP_LIB_PATH",                      AMD_LIB )
setenv ( "HSA_PATH",           AMD_CURPATH )
setenv ( "ROCMINFO_PATH",      AMD_CURPATH )
setenv ( "HIP_PLATFORM",                        "amd" )
setenv ( "CRAY_CCE_ROCM_LIB_PATH",            AMD_GCN )
setenv ( "DEVICE_LIB_PATH",                   AMD_GCN )
setenv ( "HIP_DEVICE_LIB_PATH",               AMD_GCN )
setenv ( "HIP_CLANG_PATH",                    AMD_LLVM_BIN )
setenv ( "LLVM_PATH",                         AMD_LLVM )
prepend_path ( "LD_LIBRARY_PATH",    AMD_LIB64 )
prepend_path ( "PATH",               AMD_HIP_BIN )
prepend_path ( "CMAKE_PREFIX_PATH",  AMD_CURPATH )
prepend_path ( "CMAKE_PREFIX_PATH",  AMD_HIP )
prepend_path ( "XLOCALEDIR",      "/usr/share/X11/locale" )
append_path  ( "HIPCC_COMPILE_FLAGS_APPEND", "--rocm-path=" .. AMD_CURPATH)
