abstract type TwuAlphaModel <: AlphaModel end

struct TwuAlphaParam <: EoSParam
    M::SingleParam{Float64}
    N::SingleParam{Float64}
    L::SingleParam{Float64}
end

@newmodelsimple TwuAlpha TwuAlphaModel TwuAlphaParam
default_locations(::Type{TwuAlpha}) = ["alpha/Twu/Twu_like.csv"]
default_references(::Type{TwuAlpha}) = ["10.1016/0378-3812(80)80003-3"]
export TwuAlpha

"""
    TwuAlpha <: TwuAlphaModel
    
    TwuAlpha(components;
    userlocations=String[],
    verbose::Bool=false)
## Input Parameters
- `M`: Single Parameter
- `N`: Single Parameter
- `L`: Single Parameter
## Model Parameters
- `M`: Single Parameter
- `N`: Single Parameter
- `L`: Single Parameter
## Description
Cubic alpha `(α(T))` model. Default for [`VTPR`](@ref) EoS. Also known as Twu-91 alpha
```
αᵢ = Trᵢ^(N*(M-1))*exp(L*(1-Trᵢ^(N*M))
Trᵢ = T/Tcᵢ
```
## References
1. Twu, C. H., Lee, L. L., & Starling, K. E. (1980). Improved analytical representation of argon thermodynamic behavior. Fluid Phase Equilibria, 4(1–2), 35–44. [doi:10.1016/0378-3812(80)80003-3](https://doi.org/10.1016/0378-3812(80)80003-3)
"""
TwuAlpha

const Twu91Alpha = TwuAlpha

"""
    Twu88Alpha::TwuAlpha
    
    Twu88Alpha(components::Vector{String};
    userlocations=String[],
    verbose::Bool=false)
## Input Parameters
- `M`: Single Parameter
- `N`: Single Parameter (optional)
- `L`: Single Parameter 
## Model Parameters
- `M`: Single Parameter
- `N`: Single Parameter
- `L`: Single Parameter
## Description
Cubic alpha `(α(T))` model. Also known as Twu-88 alpha.
```
αᵢ = Trᵢ^(N*(M-1))*exp(L*(1-Trᵢ^(N*M))
N = 2
Trᵢ = T/Tcᵢ
```
if `N` is specified, it will be used.

## References
1. Twu, C. H., Lee, L. L., & Starling, K. E. (1980). Improved analytical representation of argon thermodynamic behavior. Fluid Phase Equilibria, 4(1–2), 35–44. [doi:10.1016/0378-3812(80)80003-3](https://doi.org/10.1016/0378-3812(80)80003-3)
"""
function Twu88Alpha(components::Vector{String}; userlocations=String[], verbose::Bool=false)
    params = getparams(components, ["alpha/Twu/Twu_like.csv"]; userlocations=userlocations, verbose=verbose,ignore_missing_singleparams = ["N"])
    M = params["M"]
    N = params["N"]
    L = params["L"]

    n = length(components)
    for i in 1:n
        if N.ismissingvalues[i]
            N[i] = 2
        end
    end
    packagedparams = TwuAlphaParam(M,N,L)
    model = TwuAlpha(packagedparams, verbose=verbose)
    return model
end

function α_function(model::CubicModel,V,T,z,alpha_model::TwuAlphaModel)
    Tc = model.params.Tc.values
    _M  = alpha_model.params.M.values
    _N  = alpha_model.params.N.values
    _L  = alpha_model.params.L.values
    α = zeros(typeof(T*1.0),length(Tc))
    for i in @comps
        M = _M[i]
        N = _N[i]
        L = _L[i]
        Tr = T/Tc[i]
        α[i] = Tr^(N*(M-1))*exp(L*(1-Tr^(N*M)))
    end
    return α
end

function α_function(model::CubicModel,V,T,z::SingleComp,alpha_model::TwuAlphaModel)
    Tc = model.params.Tc.values[1]
    M  = alpha_model.params.M.values[1]
    N  = alpha_model.params.N.values[1]
    L  = alpha_model.params.L.values[1]
    Tr = T/Tc
    α = Tr^(N*(M-1))*exp(L*(1-Tr^(N*M)))
end

export TwuAlpha, Twu88Alpha, Twu91Alpha
