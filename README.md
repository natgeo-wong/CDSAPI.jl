# **<div align="center">CDSAPI.jl</div>**

<p align="center">
  <a href="https://www.repostatus.org/#active">
    <img alt="Repo Status" src="https://www.repostatus.org/badges/latest/active.svg?style=flat-square" />
  </a>
  <a href="https://travis-ci.com/github/JuliaClimate/CDSAPI.jl">
    <img alt="Travis CI" src="https://travis-ci.org/JuliaClimate/CDSAPI.jl.svg?branch=master&style=flat-square">
  </a>
  <a href="https://codecov.io/gh/JuliaClimate/CDSAPI.jl">
    <img alt="CodeCov" src="https://codecov.io/gh/JuliaClimate/CDSAPI.jl/branch/master/graph/badge.svg">
  </a>
  <br>
  <a href="https://mit-license.org">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square">
  </a>
  <img alt="Latest Release" src="https://img.shields.io/github/v/release/JuliaClimate/CDSAPI.jl">
  <a href="https://JuliaClimate.github.io/CDSAPI.jl/stable/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-stable-blue.svg?style=flat-square">
  </a>
  <a href="https://JuliaClimate.github.io/CDSAPI.jl/dev/">
    <img alt="Latest Documentation" src="https://img.shields.io/badge/docs-latest-blue.svg?style=flat-square">
  </a>
</p>

**Contributors:** @michiboo @juliohm @LakshyaKhatri @natgeo-wong

## Introduction

This package provides access to the [Climate Data Store](https://cds.climate.copernicus.eu) (a.k.a. CDS) service.

The CDS website provides a [Show API request](https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-pressure-levels-monthly-means?tab=form) button at the bottom of the download tab of each dataset. This button generates the code to download the dataset with the Python cdsapi module. We've designed this Julia package so that one could copy/paste the generated Python code with minimum modification in Julia.

`CDSAPI.jl` can be installed via
```
] add CDSAPI
```

## Requirements
You must have a CDS account and have ensured that your `~/.cdsapirc` file exists. Instructions on how to create the file for your user account can be found [here](https://cds.climate.copernicus.eu/api-how-to).
