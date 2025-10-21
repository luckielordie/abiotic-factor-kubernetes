# Abiotic Factor Kubernetes

A way to run an Abiotic Factor server on kubernetes.

https://github.com/DFJacob/AbioticFactorDedicatedServer/issues/3#issuecomment-2094369127
https://github.com/Pleut/abiotic-factor-linux-docker/tree/main
https://github.com/DFJacob/AbioticFactorDedicatedServer/wiki/Guide-%E2%80%90-Quickstart


## How to Find Your Variables (Step-by-Step)
The only tool you need is SteamDB.

Let's use Abiotic Factor as our example.

### Step 1: Find the STEAM_APP_ID
Go to steamdb.info.

In the search bar, search for your game's dedicated server, not the game itself.

Search for "Abiotic Factor Dedicated Server".

You'll see it in the results. The APPID is your STEAM_APP_ID.

STEAM_APP_ID: 2857200

### Step 2: Find the STEAM_DEPOT_ID
Click on the App ID (2857200) to go to its page.

On the left-hand menu, click on "Depots".

You'll see a list of all the "boxes" for this app. You need the one for the Windows server.

The name "Abiotic Factor Dedicated Server" is the one you want. The DEPOTID is in the first column.

STEAM_DEPOT_ID: 2857201

### Step 3: Find the STEAM_MANIFEST_ID
From the Depots page, click on the Depot ID you just found (2857201).

On the left-hand menu, click on "Manifests".

This page shows a complete history of every version (snapshot) ever pushed for this depot.

Find the version you want (usually the top one for the latest, or scroll down to find an older version from a specific date).

Copy the long number in the "MANIFEST ID" column.

STEAM_MANIFEST_ID: (Example) 5370878496015047913