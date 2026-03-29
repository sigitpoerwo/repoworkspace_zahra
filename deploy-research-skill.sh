#!/bin/bash
# Deploy Academic Research Skill to AWS OpenClaw

echo "=== Deploying Academic Research Assistant Skill ==="

# Navigate to workspace
cd ~/.openclaw/workspace

# Pull latest from GitHub
echo "Step 1: Pulling latest from GitHub..."
git pull origin main

# Restart gateway to load new skill
echo "Step 2: Restarting gateway..."
openclaw gateway restart

# Wait for gateway to start
sleep 5

# Verify skill loaded
echo "Step 3: Verifying skill..."
openclaw skills list | grep -i "academic-research"

echo ""
echo "=== Deployment Complete ==="
echo "Test the skill: Ask Joni about research topics in management or digital business"
