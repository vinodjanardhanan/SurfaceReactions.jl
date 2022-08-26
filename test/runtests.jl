using SurfaceReactions
using Test
using LightXML
using IdealGas
using RxnHelperUtils
using ReactionCommons


@testset "SurfaceReactions.jl" begin
        
    # if Sys.isapple() || Sys.islinux()
    #     retcode = SurfaceReactions.run("schem.xml","lib/")
    #     @test abs(retcode) < 1e-9 
    # elseif Sys.iswindows()
    #     retcode = SurfaceReactions.run("schem.xml","lib\\")
    #     @test abs(retcode) < 1e-9
    # end

    
    input_file = "schem.xml"
    if Sys.isapple() || Sys.islinux()
        lib_dir = "lib/"
    elseif Sys.iswindows()
        lib_dir = "lib\\"
    end 
    local gasphase = Array{String,1}()    

    xmldoc = parse_file(input_file)
    xmlroot = root(xmldoc)
    #Read the gasphase
    #tag_gasphase = get_elements_by_tagname(xmlroot,"gasphase")
    gasphase = get_collection_from_xml(xmlroot,"gasphase")

    thermo_file = lib_dir*"therm.dat"
    thermo_obj = IdealGas.create_thermo(gasphase, thermo_file)        
    
    #Get the molefractions
    mole_fracs = get_molefraction_from_xml(xmlroot,thermo_obj.molwt,gasphase)
    
    #Read the temperature xml
    local T = get_value_from_xml(xmlroot,"T")
    #Get the pressure from xml
    local p = get_value_from_xml(xmlroot,"p")
    

    #Get the mechanism file from xml
    local mech_file = get_text_from_xml(xmlroot,"mech")

    
    mech_file = lib_dir*mech_file
    
    md = SurfaceReactions.compile_mech(mech_file,thermo_obj,gasphase)
    covg = md.sm.si.ini_covg
    n_species = length(gasphase)+length(md.sm.species)
    rate = zeros(n_species)    
    all_conc = zeros(n_species)    
    surf_conc = zeros(length(covg))
    rxn_rate = zeros(length(md.sm.reactions))
    #Create the state object    
    state = SurfaceRxnState(T, p, mole_fracs, covg, surf_conc ,  rxn_rate , rate, all_conc)

    #calculate the molar production rates    
    t, state = SurfaceReactions.calculate_ss_molar_production_rates!(state,thermo_obj,md,10.0)

    retcode = sum(state.source[length(state.mole_frac)+1:end])

    @test abs(retcode) < 1e-9

end

