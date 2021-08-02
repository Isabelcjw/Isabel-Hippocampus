#!/bin/bash

set -e

mkdir -p output

# Preprocess
ml-run-process ephys.bandpass_filter \
	--inputs timeseries:dataset/raw_data.mda \
	--outputs timeseries_out:output/filt.mda.prv \
	--parameters samplerate:30000 freq_min:300 freq_max:6000
ml-run-process ephys.whiten \
	--inputs timeseries:output/filt.mda.prv \
	--outputs timeseries_out:output/pre.mda.prv

# Spike sorting
ml-run-process ms4alg.sort \
	--inputs \
		timeseries:output/pre.mda.prv geom:dataset/geom.csv \
	--outputs \
		firings_out:output/firings.mda \
	--parameters \
		detect_sign:0 \
		adjacency_radius:0 \
		detect_interval:30 \
		detect_threshold:4 \
		max_num_clips_for_pca:2000 \ 

# Compute templates
ml-run-process ephys.compute_templates \
	--inputs timeseries:dataset/raw_data.mda firings:output/firings.mda \
	--outputs templates_out:output/templates.mda.prv \
	--parameters \
		clip_size:150

ml-run-process ephys.compute_cluster_metrics \
    --inputs firings:output/firings.mda timeseries:dataset/raw_data.mda \
    --outputs metrics_out:output/metrics.json \
    --parameters \
        clip_size:150 \
        samplerate:30000.0 \
        refrac_msec:1.0 \


