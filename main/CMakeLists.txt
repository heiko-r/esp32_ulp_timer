idf_component_register(
    SRCS "main.c"
    INCLUDE_DIRS ""
    REQUIRES soc ulp
)

# ULP app name (must be unique)
set(ulp_app_name ulp_${COMPONENT_NAME})

# Assembly source files, should be placed in separate directory
set(ulp_s_sources "ulp/counter.S")

# Component source files which include the automatically generated ULP export
# file, ${upl_app_name}.h (w/o ULP assembly source files)
set(ulp_exp_dep_srcs "main.c")

# Build ULP binary and embed it into project
ulp_embed_binary(${ulp_app_name} "${ulp_s_sources}" "${ulp_exp_dep_srcs}")