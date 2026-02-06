var month = 0;

function saveState() {
    state.scriptProps = {
        month: month,
    };
}

var LEVEL_THRESHOLDS = [0, 3000, 9000];
var JUNGLE_LIMIT = 4; // the amount of jungle creeps that spawn in a camp
var teamOneLevel = 1;
var teamTwoLevel = 1;

var PLAYER_DATA = [
    { player: null, team: 1, base: null, path: 0 },
    { player: null, team: 1, base: null, path: 0 },
    { player: null, team: 1, base: null, path: 0 },
    { player: null, team: 2, base: null, path: 0 },
    { player: null, team: 2, base: null, path: 0 },
    { player: null, team: 2, base: null, path: 0 }
];

var HERO_PATHS = [
    {
        name: "Miners",
        levels: [Unit.DwarfChampion, Unit.HorseMaiden, Unit.HippogriffHero],
        techs: [null, null, null],
        bonus: [
            {id: ConquestBonus.BForgeRelics, isAdvanced: true},
            null,
            null
        ],
        messages: [
            "[HERO Lv.1]: Dwarven Operative. Slow miner and smith. -50% Relic cost and time", // path 1
            "[HERO Lv.2]: Eitria. Moderate miner and smith, can fight outside your territory.", // path 2
            "[HERO Lv.3]: Sindri. Fast miner and smith, can fight and mine outside your territory.", // path 3
        ]
    },
    {
        name: "Fighters",
        levels: [Unit.Berserker, Unit.Berserker03, Unit.EagleHero],
        techs: [null, Tech.GotBerserk, null],
        bonus: [
            {id: ConquestBonus.BOffensiveCivilian, isAdvanced: true},
            {id: ConquestBonus.BWarband, isAdvanced: true},
            {id: ConquestBonus.BGlacialWinds, isAdvanced: true}
        ],
        messages: [
            "[HERO Lv.1]: Berserker. High damage, low defense. Civilians can enter neutral zones", // path 4
            "[HERO Lv.2]: Egil. Gains Dominion ability to colonize zones for free. +5 Warband", // path 5
            "[HERO Lv.3]: Grif. Swift assassin, can freeze zones for 30 seconds.", // path 6
        ]
    },
    {
        name: "Defender",
        levels: [Unit.BearMaiden, Unit.TurtleHero, Unit.RatMaiden],
        techs: [null, null, null],
        bonus: [
            {id: ConquestBonus.BWinter, isAdvanced: true},
            null,
            {id: ConquestBonus.BHousePopulation, isAdvanced: true}
        ],
        messages: [
            "[HERO Lv.1]: Kaija. Slow tank, fishes for food, regenerates health. -25% Winter severity", // path 7
            "[HERO Lv.2]: Njörd. Durable tank, reduces upgrade and purchase costs.", // path 8
            "[HERO Lv.3]: Eir. Strong tank, heals all allies in her zone. +1 House space", // path 9
        ]
    }
];

// =============================================================================

var CAMPS = [
    {
        name: "Food",
        levels: [Unit.SpecterWarrior, Unit.IdavollValkyrie, Unit.IceGolem],
        location: [
            { zone: 153 },
            { zone: 230 },
            { zone: 148 },
            { zone: 79 },
        ],
    },
    {
        name: "Wood",
        levels: [Unit.Lightalfar, Unit.DwarfChampion, Unit.Valkyrie],
        location: [
            { zone: 165 },
            { zone: 219 },
            { zone: 139 },
            { zone: 88 },
        ],
    },
    {
        name: "Krowns",
        levels: [Unit.Myrkalfar, Unit.DwarfKingFoe, Unit.UndeadGiant],
        location: [
            { zone: 171 },
            { zone: 212 },
            { zone: 132 },
            { zone: 94 },
        ],
    },
    {
        name: "Ores",
        levels: [null, Unit.SmallGolem, Unit.RimesteelGolem],
        location: [
            { zone: 184 },
            { zone: 202 },
            { zone: 124 },
            { zone: 106 },
        ],
    }
];

var LANE_DATA = [
    {
        name: "Top",
        zones: [29, 43, 51, 62, 64, 73, 84, 93, 100],
    },
    {
        name: "Mid",
        zones: [121, 130, 135, 147, 155, 169, 178, 185, 196],
    },
    {
        name: "Bot",
        zones: [206, 208, 220, 232, 237, 248, 260, 267, 277],
    }
];

var BOSS_DATA = [
    // Level 1
    {
        name: "Savage Jötunn",
        unit: Unit.Giant,
        escorts: [],
        escortCount: 0,
        level: 1,
        loreBonus: [],
		conquestBonus: [],
		alive: false,
		message: "[BOSS Lv.1]: Savage Jötunn. Hits hard, weak to projectiles. Kill reward: \n",
    },
    {
        name: "Vanr",
        unit: Unit.Vanir,
        escorts: [Unit.Lightalfar],
        escortCount: 4,
        level: 1,
        loreBonus: [],
		conquestBonus: [],
		alive: false,
		message: "[BOSS Lv.1]: Vanr with 4 Ljósálf. Low stats but deadly poison. Kill reward: \n",
    },
    {
        name: "Colossal Boar",
        unit: Unit.ColossalBoar,
        escorts: [],
        escortCount: 0,
        level: 1,
        loreBonus: [],
		conquestBonus: [],
		alive: false,
		message: "[BOSS Lv.1]: Colossal Boar. Regenerates health quickly. Kill reward: \n",

    },
    // Level 2
    {
        name: "Jötunn Champion",
        unit: Unit.GiantHero,
        escorts: [Unit.IdavollValkyrie],
        escortCount: 4,
        level: 2,
        loreBonus: [],
		conquestBonus: [],
		alive: false,
		message: "[BOSS Lv.2]: Jötunn Champion with 4 True Valkyries. Kill reward: \n",
    },
    {
        name: "Rock Golem",
        unit: Unit.Golem,
        escorts: [],
        escortCount: 0,
        level: 2,
        loreBonus: [],
		conquestBonus: [],
		alive: false,
		message: "[BOSS Lv.2]: Rock Golem. Burns enemies with molten lava. Kill reward: \n",
    },
    {
        name: "Iron Golem",
        unit: Unit.IronGolem,
        escorts: [],
        escortCount: 0,
        level: 2,
        loreBonus: [],
		conquestBonus: [],
		alive: false,
		message: "[BOSS Lv.2]: Iron Golem. Metal core makes it very resistant. Kill reward: \n",
    },
    // Level 3
    {
        name: "Valdemar",
        unit: Unit.LichKing,
        escorts: [],
        escortCount: 0,
        level: 3,
        loreBonus: [],
		conquestBonus: [],
		alive: false,
		message: "[BOSS Lv.3]: Valdemar the Cursed with 6 Ice Golems. Kill reward: \n",
    },
    {
        name: "Erlking",
        unit: Unit.Dracula,
        escorts: [Unit.Death],
        escortCount: 6,
        level: 3,
        loreBonus: [],
		conquestBonus: [],
		alive: false,
		message: "[BOSS Lv.3]: The Erlking with 6 Servants. Kill reward: \n",
    },
    {
        name: "Young Wyvern",
        unit: Unit.BabyWyvern,
        escorts: [],
        escortCount: 0,
        level: 3,
        loreBonus: [],
		conquestBonus: [],
		alive: false,
		message: "[BOSS Lv.3]: Young Wyvern. Fast and aggressive, don't underestimate the area damage. Kill reward: \n",
    }
];

var BOSS_ZONES = [113, 193];


// =============================================================================

var CONQUEST_REWARDS = [
    // Level 1
    { level: 1, bonus: [{id: ConquestBonus.BUnitFree, isAdvanced: true}], taken: false },
    { level: 1, bonus: [{id: ConquestBonus.BMoreSheeps, isAdvanced: true}], taken: false },
    { level: 1, bonus: [{id: ConquestBonus.BColonizeCost, isAdvanced: true}], taken: false },
    { level: 1, bonus: [{id: ConquestBonus.BFarColonize, isAdvanced: true}], taken: false },
    { level: 1, bonus: [{id: ConquestBonus.BFeast, isAdvanced: true}], taken: false },
    { level: 1, bonus: [{id: ConquestBonus.BNiflheimVampirism, isAdvanced: true}], taken: false },

    // Level 2
    { level: 2, bonus: [{id: ConquestBonus.BNiflheimBarricades, isAdvanced: true}], taken: false },
    { level: 2, bonus: [{id: ConquestBonus.BNiflheimTowers, isAdvanced: true}], taken: false },
    { level: 2, bonus: [{id: ConquestBonus.BMuspelheimAoEUnits, isAdvanced: true}], taken: false },
    { level: 2, bonus: [{id: ConquestBonus.BMuspelheimTowers, isAdvanced: true}], taken: false },
    { level: 2, bonus: [{id: ConquestBonus.BPopGrowth, isAdvanced: true}], taken: false },
    { level: 2, bonus: [{id: ConquestBonus.BHappyBonus, isAdvanced: true}], taken: false },
    { level: 2, bonus: [{id: ConquestBonus.BAltar, isAdvanced: true}], taken: false },
    { level: 2, bonus: [{id: ConquestBonus.BStagFame2, isAdvanced: true}], taken: false },
    { level: 2, bonus: [{id: ConquestBonus.BSiloImproved, isAdvanced: true}], taken: false },
    { level: 2, bonus: [{id: ConquestBonus.BSilo, isAdvanced: true}], taken: false },

    // Level 3
    { level: 3, bonus: [{id: ConquestBonus.BIdavollThunderTower, isAdvanced: true}], taken: false },
    { level: 3, bonus: [{id: ConquestBonus.BIdavollThunderBarricades, isAdvanced: true}], taken: false },
    { level: 3, bonus: [{id: ConquestBonus.BUnlimitedRelics, isAdvanced: true}], taken: false },
    { level: 3, bonus: [{id: ConquestBonus.BHeartyLife, isAdvanced: true}], taken: false },
    { level: 3, bonus: [{id: ConquestBonus.BExplodingTowers, isAdvanced: true}], taken: false },
    { level: 3, bonus: [{id: ConquestBonus.BMultipleTowers, isAdvanced: true}], taken: false },
];

var LORE_REWARDS = [
    // Level 1
    { level: 1, tech: Tech.ChainTasks, taken: false },
    // Level 2
    { level: 2, tech: Tech.FeastResist, taken: false },
    { level: 2, tech: Tech.Dedication, taken: false },
    // Level 3
    { level: 3, tech: Tech.StolenLore, taken: false },
    { level: 3, tech: Tech.MilitaryWolf, taken: false },
    { level: 3, tech: Tech.BearAwake, taken: false },
];

// =============================================================================

function init() {
    if (state.time == 0)
        onFirstLaunch();
    onEachLaunch();
}

function onFirstLaunch() {
    if (isHost()) {
        setupPlayers();
        setupObjectives();
        setupRules();
    }
}

function onEachLaunch() {
}

function regularUpdate(dt: Float) {
    if (isHost()) {
        // Monthly
        if (math.floor((state.time / 60)) > month) {
            month++;
            aiCheat();

            // Every 2 months (when month is even)
            if (month % 2 == 0) {
                spawnLaneCreeps();
                spawnJungleCamps();
            }

            // Boss spawning (every 12 months)
            if (month % 12 == 0) {
                spawnBoss();
            }
        }

        // every tick (0.5s)
        trackTeamXP();
        pathUpgrades();
        checkVictoryConditions();
    }
}

// =============================================================================

function setupPlayers() {
	// Team 1
    PLAYER_DATA[0].player = getZone(206).owner;
    PLAYER_DATA[0].base = getZone(206);
    PLAYER_DATA[1].player = getZone(121).owner;
    PLAYER_DATA[1].base = getZone(121);
    PLAYER_DATA[2].player = getZone(29).owner;
    PLAYER_DATA[2].base = getZone(29);
    setAlly(PLAYER_DATA[1].player, PLAYER_DATA[0].player);
    setAlly(PLAYER_DATA[2].player, PLAYER_DATA[0].player);

	// Team 2
    PLAYER_DATA[3].player = getZone(277).owner;
    PLAYER_DATA[3].base = getZone(277);
    PLAYER_DATA[4].player = getZone(196).owner;
    PLAYER_DATA[4].base = getZone(196);
    PLAYER_DATA[5].player = getZone(100).owner;
    PLAYER_DATA[5].base = getZone(100);
	setAlly(PLAYER_DATA[4].player, PLAYER_DATA[3].player);
    setAlly(PLAYER_DATA[5].player, PLAYER_DATA[3].player);

}

function setupObjectives() {
	@sync for (p in PLAYER_DATA) {
		if (!p.player.isAI) {
			p.player.objectives.add("waveTimer", "Minions and Jungle respawn in:", {visible:true, showProgressBar: true, showOtherPlayers: false, val:0.0, goalVal:120});
			p.player.objectives.add("botBoss", "Botlane Boss respawns in:", {visible:true, showProgressBar: true, showOtherPlayers: false, val:0.0, goalVal:720});
			p.player.objectives.add("topBoss", "Toplane Boss respawns in:", {visible:true, showProgressBar: true, showOtherPlayers: false, val:0.0, goalVal:720});
		}
	}
}

function setupRules() {
    state.removeVictory(Victory.Fame);
    state.removeVictory(Victory.Money);
    state.removeVictory(Victory.Lore);
    state.removeVictory(Victory.Outsiders);
    state.removeVictory(Victory.Yggdrasil);
    state.removeVictory(Victory.OdinSword);
    state.removeVictory(Victory.Helheim);

	addRule(Rule.NoMaxTerritoryExpand);
	addRule(Rule.AggressiveIA);
	addRule(Rule.ManyResources);
	addRule(Rule.IANeedColonize);
	addRule(Rule.NeedDefense);
	for (p in PLAYER_DATA) {

		// Starter AI Buffs (AI will get more buffs as game goes on)
		if (p.player.isAI) {
			p.player.setAILevel(5);
			p.player.addBonus({id:ConquestBonus.BMultipleTowers, isAdvanced:true});
			p.player.addBonus({id:ConquestBonus.BResBonus, resId:Resource.Food, isAdvanced:false});
			p.player.addBonus({id:ConquestBonus.BResBonus, resId:Resource.Wood, isAdvanced:false});
			p.player.addBonus({id:ConquestBonus.BResBonus, resId:Resource.Money, isAdvanced:false});
			p.player.addBonus({id:ConquestBonus.BResBonus, resId:Resource.Lore, isAdvanced:false});
		}

		// Forbid colonize of jungle
		for (camp in CAMPS) {
			for (loc in camp.location) {
				p.player.allowColonize(getZone(loc.zone), false);
			}
		}
		for (zone in BOSS_ZONES) {
			p.player.allowColonize(getZone(zone), false);
		}
	}
}

function aiCheat() {
	for (p in PLAYER_DATA) {
		if (p.player.isAI) {
			p.player.setAILevel(math.floor((month/12)+5));
			p.player.addResource(Resource.MilitaryXP, math.floor(month));
			p.player.addResource(Resource.Gemstone, math.floor(0.75 + (month/24)));
			if (p.player.getResource(Resource.Food) < 300) {
				p.player.addResource(Resource.Food, math.floor(300 + month*5));
			}
			if (p.player.getResource(Resource.Wood) < month*15) {
				p.player.addResource(Resource.Wood, math.floor(month*10));
			}
			if (p.player.getResource(Resource.Money) < month*15) {
				p.player.addResource(Resource.Money, math.floor(month*10));
			}

			// Villager Buff for Kingdom Clans
			if (p.player.clan == Clan.Carolingians || p.player.clan == Clan.Stoat || p.player.clan == Clan.Hippogriff) {
				if (p.player.getUnits(Unit.Peon).length < math.floor(month/4)) {
					p.base.addUnit(Unit.Peon, 1, p.player);
				}
				if (p.player.getMilitaryCount(null, true) < math.floor(month/6)) {
					p.base.addUnit(Unit.Warrior02, 1, p.player);
				}

			// Villager Buff for Viking Clans
			} else {
				if (p.player.getUnits(Unit.Villager).length < math.floor(month/4)) {
					p.base.addUnit(Unit.Villager, 1, p.player);
				}
				if (p.player.getMilitaryCount(null, true) < math.floor(month/6)) {
					p.base.addUnit(Unit.Warrior, 1, p.player);
				}
			}
		}
	}
}


// =============================================================================

function pathUpgrades() {
    @sync for (p in PLAYER_DATA) {
        if (p.player == null) continue;

        switch (p.path) {
            // No path yet
            case 0:
                p.path = checkPathSelection(p);

            // ===== MINER PATH =====
            case 1:
                if (canUpgradeToLevel(p, 2)) {
                    p.base.addUnit(HERO_PATHS[0].levels[1], 1, p.player);
                    p.player.genericNotify(HERO_PATHS[0].messages[1]);
                    p.path = 2;
                }

            case 2:
                if (canUpgradeToLevel(p, 3)) {
                    p.base.addUnit(HERO_PATHS[0].levels[2], 1, p.player);
                    p.player.genericNotify(HERO_PATHS[0].messages[2]);
                    p.path = 3;
                }

            case 3:
                // Miner maxed

            // ===== FIGHTER PATH =====
            case 4:
                if (canUpgradeToLevel(p, 2)) {
                    p.base.addUnit(HERO_PATHS[1].levels[1], 1, p.player);
                    p.player.unlockTech(HERO_PATHS[1].techs[1]);
                    p.player.addBonus(HERO_PATHS[1].bonus[1]);
                    p.player.genericNotify(HERO_PATHS[1].messages[1]);
                    p.path = 5;
                }

            case 5:
                if (canUpgradeToLevel(p, 3)) {
                    p.base.addUnit(HERO_PATHS[1].levels[2], 1, p.player);
                    p.player.addBonus(HERO_PATHS[1].bonus[2]);
                    p.player.genericNotify(HERO_PATHS[1].messages[2]);
                    p.path = 6;
                }

            case 6:
                // Fighter maxed

            // ===== DEFENDER PATH =====
            case 7:
                if (canUpgradeToLevel(p, 2)) {
                    p.base.addUnit(HERO_PATHS[2].levels[1], 1, p.player);
                    p.player.genericNotify(HERO_PATHS[2].messages[1]);
                    p.path = 8;
                }

            case 8:
                if (canUpgradeToLevel(p, 3)) {
                    p.base.addUnit(HERO_PATHS[2].levels[2], 1, p.player);
                    p.player.addBonus(HERO_PATHS[2].bonus[2]);
                    p.player.genericNotify(HERO_PATHS[2].messages[2]);
                    p.path = 9;
                }

            case 9:
                // Defender maxed
        }
    }
}


function checkPathSelection(p) {
    // Check if player built a forge or mine building
    if (p.player.getBuilding(Building.Forge) != null ||
        p.player.getBuilding(Building.ForgeHorse) != null ||
        p.player.getBuilding(Building.AllMines) != null ||
        p.player.getBuilding(Building.QuarryStone) != null ||
        p.player.getBuilding(Building.Smithy) != null ||
        p.player.getBuilding(Building.HippogriffForge) != null) {

        var pathTaken = [for (player in PLAYER_DATA) if (player.path == 1 && player.team == p.team) player].length > 0;

        if (!pathTaken) {
            p.base.addUnit(HERO_PATHS[0].levels[0], 1, p.player);  // Dwarven Operative
            p.player.addBonus(HERO_PATHS[0].bonus[0]);
            p.player.genericNotify(HERO_PATHS[0].messages[0]);
            return 1;
        }
    }

    // Check if player built a warcamp
    if (p.player.getResource(Resource.Warband) > 0) {
        var pathTaken = [for (player in PLAYER_DATA) if (player.path == 4 && player.team == p.team) player].length > 0;

        if (!pathTaken) {
            p.base.addUnit(HERO_PATHS[1].levels[0], 1, p.player);  // Berserker
            p.player.addBonus(HERO_PATHS[1].bonus[0]);
            p.player.genericNotify(HERO_PATHS[1].messages[0]);
            return 4;
        }
    }

    // Check if player built a money building
    if (p.player.getBuilding(Building.TradingPost) != null ||
        p.player.getBuilding(Building.MarketPlace) != null ||
        p.player.getBuilding(Building.Port) != null ||
        p.player.getBuilding(Building.RavenPort) != null ||
        p.player.getBuilding(Building.KrownPicker) != null ||
        p.player.getBuilding(Building.CaroPort) != null) {

        var pathTaken = [for (player in PLAYER_DATA) if (player.path == 7 && player.team == p.team) player].length > 0;

        if (!pathTaken) {
            p.base.addUnit(HERO_PATHS[2].levels[0], 1, p.player);  // Kaija
            p.player.addBonus(HERO_PATHS[2].bonus[0]);
            p.player.genericNotify(HERO_PATHS[2].messages[0]);
            return 7;
        }
    }

	return 0;  // No path selected

}


function trackTeamXP() {
    var teamOneXP = 0;
    var teamTwoXP = 0;
    for (p in PLAYER_DATA) {
        if (p.team == 1) {
            teamOneXP = teamOneXP + math.floor(p.player.getResource(Resource.MilitaryXP));
        } else {
            teamTwoXP = teamTwoXP + math.floor(p.player.getResource(Resource.MilitaryXP));
        }
    }
    if (teamOneXP >= LEVEL_THRESHOLDS[2]) {
        teamOneLevel = 3;
    } else if (teamOneXP >= LEVEL_THRESHOLDS[1]) {
        teamOneLevel = 2;
    }
    if (teamTwoXP >= LEVEL_THRESHOLDS[2]) {
        teamTwoLevel = 3;
    } else if (teamTwoXP >= LEVEL_THRESHOLDS[1]) {
        teamTwoLevel = 2;
    }
}


// =============================================================================

function spawnJungleCamps() {
	var tier = math.floor(math.max(teamOneLevel, teamTwoLevel) - 1);

	// safety checks
	if (tier < 0) tier = 0;
    if (tier > 2) tier = 2;

	@sync for (camp in CAMPS) {
		var unitType = camp.levels[(tier)];
		if (unitType == null) continue;

		for (loc in camp.location) {
			var z = getZone(loc.zone);
			if (z != null) {
				// Check if camp is already full
				var countFoes = 0;
				for (unit in z.units) {
					if (unit.owner == null) {
						countFoes++;
					}
				}
				// Camp is not full, add one jungle monster
				if (countFoes <= 3) {
					z.addUnit(unitType, 1, null);
				}
			}
		}
	}
}

function spawnLaneCreeps() {

}


// =============================================================================


function spawnBoss() {
	var tier = math.floor(math.max(teamOneLevel, teamTwoLevel));

	for (zone in BOSS_ZONES) {
		var bossType = chooseBoss(tier);
		// Kill old boss if alive
		var z = getZone(zone);
		for (unit in z.units) {
			if (unit.owner == null) {
				unit.die();
			}
		}

		// Spawn new boss
		z.addUnit((bossType : Dynamic).unit, 1, null);
		var bossLaneName = (zone == 193) ? "BOT >" : "TOP > ";
		var bossBonusNames = ((bossType : Dynamic).conquestBonus) ? (bossType : Dynamic).conquestBonus
		var announceBoss = (bossLaneName + (bossType : Dynamic).message + );
		sendMessage(announceBoss);
		if ((bossType : Dynamic).escortCount > 0) {
			z.addUnit((bossType : Dynamic).escorts, (bossType : Dynamic).escortCount, null);
		}
	}
}

function chooseBoss(targetLevel : Int) {
	var possibleBosses = [];
	for (boss in BOSS_DATA) {
		if (boss.level == targetLevel) {
			possibleBosses.push(boss);
		}
	}
	var randomIndex = math.floor(math.random() * possibleBosses.length);

	var selectedBoss = possibleBosses[randomIndex];
	selectedBoss.conquestBonus = [];
	selectedBoss.loreBonus = [];
	selectedBoss.alive = false;

	var isConquest = (math.random() < (2/3));
	var possibleRewards = [];
	if (isConquest) {
		for (r in CONQUEST_REWARDS) {
			if (r.level <= targetLevel && !r.taken) {
				possibleRewards.push(r);
			}
		}
		var bonusesNeeded = 2;
		while (bonusesNeeded > 0) {
			var randomIndex = math.floor(math.random() * possibleRewards.length);
			var reward = possibleRewards[randomIndex];
			for (b in reward.bonus) {
				selectedBoss.conquestBonus.push(b);
			}
			reward.taken = true;
			possibleRewards.splice(randomIndex, 1);
			bonusesNeeded--;
		}
	} else {
		for (r in LORE_REWARDS) {
			var randomIndex = math.floor(math.random() * possibleRewards.length);
			var reward = possibleRewards[randomIndex];
			for (b in reward.bonus) {
				selectedBoss.loreBonus.push(b);
			}
			reward.taken = true;
		}
	}
	return selectedBoss;
}



function trackBossDeath(): Int {
    for (p in PLAYER_DATA) {
		if (p.player.getResource(Resource.RimeSteel) > 0) {
			continue;
			}
		}
    return -1;
}


function awardBossReward(team: Int, bossLevel: Int) {

}

function checkVictoryConditions() {

}


// =============================================================================

function canUpgradeToLevel(p, level:Int):Bool {
    if (p.team == 1) {
        return teamOneLevel >= level;
    } else {
        return teamTwoLevel >= level;
    }
}

function randomRoll(max: Int): Int {
    return math.floor(math.random(max));
}

function sendMessage(message : String)  {
	@sync for (p in PLAYER_DATA) {
		p.player.genericNotify(message);
	}
}