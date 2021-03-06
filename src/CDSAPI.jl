module CDSAPI

## Base Modules Used
using Base64
using Dates
using Logging
using Printf

## Modules Used
using HTTP
using JSON

export retrieve, cdskeys

"""
    retrieve(
        dataset::AbstractString,
        params::AbstractDict,
        fname::AbstractString,
        keys::AbstractDict = cdskeys()
    )

Retrieves datasets from the Climate Data Store, with options specified in a Julia Dictionary and saves it into a specified file.

Arguments:
    * `dataset::AbstractString` : string specifies the name of the dataset within the Climate Data Store that the `retrieve` function is attempting to retrieve data from
    * `params::AbstractDict` : dictionary that contains the keywords that specify the properties (e.g. date, resolution, grid) of the data being retrieved
    * `fname::AbstractString` : string that contains the path and name of the file that the data is to be saved into
    * `keys::AbstractDict` : dictionary that contains API Key information read from the .cdsapirc file in the home directory (optional)
"""
function retrieve(
    dataset::AbstractString,
    params::AbstractDict,
    fname::AbstractString,
    keys::AbstractDict = cdskeys();
    verbose::Bool=true
)

    if verbose
        @info "$(now()) - Welcome to the Climate Data Store"
    else
        @info """$(now()) - Requesting $(uppercase(dataset)) data from the Climate Data Store ...
        """
    end
    apikey = string("Basic ", base64encode(keys["key"]))

    if verbose
        @info "$(now()) - Sending request to https://cds.climate.copernicus.eu/api/v2/resources/$(dataset) ..."
    end
    response = HTTP.request(
        "POST", keys["url"] * "/resources/$(dataset)",
        ["Authorization" => apikey],
        body=JSON.json(params),
        verbose=0
    )
    resp_dict = JSON.parse(String(response.body))
    data = Dict("state" => "queued")

    if verbose; @info "$(now()) - Request is queued" end
    while data["state"] == "queued"
        parserequest!(data)
    end

    if verbose; @info "$(now()) - Request is running" end
    while data["state"] == "running"
        parserequest!(data)
    end

    if data["state"] == "completed"

        if verbose; @info "$(now()) - Request is completed" end

        @info """$(now()) - Downloading $(uppercase(dataset)) data ...
          URL:         $(data["location"])
          Destination: $(fnc)
        """

        dt1 = now()
        HTTP.download(data["location"],fname,update_period=Inf)
        dt2 = now()

        if verbose
            @info "$(now()) - Downloaded $(@sprintf("%.1f",data["content_length"]/1e6)) MB in $(@sprintf("%.1f",Dates.value(dt2-dt1)/1000)) seconds (Rate: $(@sprintf("%.1f",data["content_length"]/1e3/Dates.value(dt2-dt1))) MB/s)"
        end

    elseif data["state"] == "failed"

        @error "$(now()) - Request failed"

    end

    return

end

"""
    cdskeys() -> Dict{Any,Any}

Retrieves the CDS API Keys from the .cdsapirc file in the home directory
"""
function cdskeys()

    keys = Dict(); cdsapirc = joinpath(homedir(),".cdsapirc")

    @info "$(now()) - Loading CDSAPI credentials from $(cdsapirc) ..."
    open(cdsapirc) do f
        for line in readlines(f)
            key,val = strip.(split(line,':',limit=2))
            keys[key] = val
        end
    end

    return keys

end

"""
    parserequest(data::AbstractDict) -> Dict{Any,Any}

Get info on HTTP request, and parse the information and update the dictionary
"""
function parserequest!(data::AbstractDict)

    data = HTTP.request(
        "GET", keys["url"] * "/tasks/" * string(resp_dict["request_id"]),
        ["Authorization" => apikey]
    )
    data = JSON.parse(String(data.body))

    return

end

end # module
