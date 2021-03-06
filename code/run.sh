#!/usr/bin/env bash
set -e

# This is the master script for the capsule. When you click "Reproducible Run", the code in this file will execute.

# Clean results
rm -rf logs/
mkdir logs
rm -rf submission_logs/
mkdir submission_logs

rm -rf benchmark/plots/
mkdir benchmark/plots/

rm -rf benchmark/benchmark_results.csv
cp benchmark/.reset_backup/benchmark_results_blank.csv benchmark/
mv benchmark/benchmark_results_blank.csv benchmark/benchmark_results.csv

# Run experiments
python run_experiments.py --exp-id 1 --algo ppo --env widowx_reacher-v1 --n-timesteps 10000 --n-seeds 2
python run_experiments.py --exp-id 2 --algo ppo --env widowx_reacher-v3 --n-timesteps 10000 --n-seeds 2

# Evaluate policy
python evaluate_policy.py --exp-id 1 --n-eval-steps 1000 --log-info 1 --plot-dim 0 --render 0
python evaluate_policy.py --exp-id 2 --n-eval-steps 1000 --log-info 1 --plot-dim 0 --render 0

# Plot evaluation episode info
python scripts/plot_episode_eval_log.py --exp-id 1
python scripts/plot_episode_eval_log.py --exp-id 2

# Plot benchmark results
python scripts/plot_benchmark.py --exp-list 1 2 --col random_goal

# Move results to results folder
cp -r logs/ ../results/
cp -r benchmark/ ../results/