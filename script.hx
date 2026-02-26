var Wave = 0;
var lastUpdateTime = -1;
var TeamBool = false;
var xpCompensation : Null<Bool> = null;
var Difficulty = 1;

var p1 = getZone(206).owner;
var p2 = getZone(121).owner;
var p3 = getZone(29).owner;
var p4 = getZone(277).owner;
var p5 = getZone(196).owner;
var p6 = getZone(100).owner;

var p1OG = p1;
var p2OG = p2;
var p3OG = p3;
var p4OG = p4;
var p5OG = p5;
var p6OG = p6;

var p1Attack:Array<Zone> = [getZone(208), getZone(220), getZone(232), getZone(237), getZone(248), getZone(260), getZone(267), getZone(277)];
var p4Attack:Array<Zone> = [getZone(267), getZone(260), getZone(248), getZone(237), getZone(232), getZone(220), getZone(208), getZone(206)];

var p2Attack:Array<Zone> = [getZone(130), getZone(135), getZone(147), getZone(155), getZone(169), getZone(178), getZone(185), getZone(196)];
var p5Attack:Array<Zone> = [getZone(185), getZone(178), getZone(169), getZone(155), getZone(147), getZone(135), getZone(130), getZone(121)];

var p3Attack:Array<Zone> = [getZone(43), getZone(51), getZone(62), getZone(64), getZone(73), getZone(84), getZone(93), getZone(100)];
var p6Attack:Array<Zone> = [getZone(93), getZone(84), getZone(73), getZone(64), getZone(62), getZone(51), getZone(43), getZone(29)];

var p1Wave:Array<Unit> = [];
var p2Wave:Array<Unit> = [];
var p3Wave:Array<Unit> = [];
var p4Wave:Array<Unit> = [];
var p5Wave:Array<Unit> = [];
var p6Wave:Array<Unit> = [];

var FoodCamp:Array<Zone> = [getZone(145), getZone(161)];
var WoodCamp:Array<Zone> = [getZone(131), getZone(172)];
var KrownsCamp:Array<Zone> = [getZone(231), getZone(76)];
var OresCamp:Array<Zone> = [getZone(214), getZone(91)];
var BossCamp:Array<Zone> = [getZone(124), getZone(184)];

var teamOneLevel = 1;
var teamTwoLevel = 1;

var teamOneBonusXP = 0.0;
var teamTwoBonusXP = 0.0;

var minerUnits = [Unit.DwarfChampion, Unit.HorseMaiden, Unit.HippogriffHero, Unit.GayantHero];
var minerBonuses1 = [ConquestBonus.BForgeRelics, ConquestBonus.BColonizeCost, ConquestBonus.BHousePopulation, ConquestBonus.BIdavollThunderUnit];
var minerBonuses2 = [ConquestBonus.BWinter, ConquestBonus.BSilo, ConquestBonus.BPopGrowth, ConquestBonus.BIdavollBlindAbility];
var minerMessages = [
    "[MINER Lv.1]: [DwarfChampion]. Slow miner and smith.\n*3 Gemstone\n* -50% [Relic] cost and time\n* -30% Winter Severity",
    "[MINER Lv.2]: [HorseMaiden]. Moderate miner and smith, can fight outside your territory.\n*3 Gemstone\n* -40% Colonize Cost\n* 20% Silo bonus",
    "[MINER Lv.3]: [HippogriffHero]. Fast miner and smith, can fight and mine outside your territory.\n*3 Gemstone\n* +3 House space\n* 60% [Population] Growth",
    "[MINER Lv.4]: [Gelon]. Strong and heavy hitting Tank with AoE.\n*3 Gemstone\n* Thunder Blades\n* Holy Blades"
];

var attackerUnits = [Unit.Berserker, Unit.Berserker03, Unit.EagleHero, Unit.Gelon];
var attackerBonuses1 = [ConquestBonus.BUnitFree, ConquestBonus.BNiflheimVampirism, ConquestBonus.BNidavellirDoTUnit, ConquestBonus.BNidavellirFearUnit];
var attackerBonuses2 = [ConquestBonus.BWarchief, ConquestBonus.BWarchiefCooldown, ConquestBonus.BMuspelheimDoTUnits, ConquestBonus.BMuspelheimAoEUnits];
var attackerMessages = [
    "[FIGHTER Lv.1]: [Berserker]. High damage, low defense.\n*3 Gemstone\n* First 3 Units free\n* -50% Warchief cost",
    "[FIGHTER Lv.2]: [Berserker03]. Bigger brother of the Berserker.\n*3 Gemstone\n* Lifesteal Blades\n* -40% Warchief/Relic Cooldown",
    "[FIGHTER Lv.3]: [EagleHero]. Swift assassin with ranged attacks.\n*3 Gemstone\n* Poison Blades\n* Fire Blades",
    "[FIGHTER Lv.4]: [GayantHero]. Unstoppable Mage that one shots units.\n*3 Gemstone\n* Terror Blades\n* Cleave Blades"
];

var defenderUnits = [Unit.BearMaiden, Unit.TurtleHero, Unit.RatMaiden, Unit.GiantHero];
var defenderBonuses1 = [ConquestBonus.BWarband, ConquestBonus.BCaCTowers, ConquestBonus.BMultipleTowers, ConquestBonus.BNiflheimUnit];
var defenderBonuses2 = [ConquestBonus.BColonizeCost, ConquestBonus.BExplodingTowers, ConquestBonus.BSilo, ConquestBonus.BVanaheimRootUnit];
var defenderMessages = [
    "[DEFENDER Lv.1]: [BearMaiden]. Slow tank, fishes for food, regenerates health.\n*3 Gemstone\n* -40% Colonize Cost\n* +3 Warband",
    "[DEFENDER Lv.2]: [TurtleHero]. Durable tank, reduces upgrade and purchase costs.\n*3 Gemstone\n* +40% Tower HP\n* Exploding Towers",
    "[DEFENDER Lv.3]: [RatMaiden]. Strong tank, heals all allies in the zone.\n*3 Gemstone\n* Build 2 towers per zone\n* 20% Silo bonus",
    "[DEFENDER Lv.4]: [GiantHero]. Immovable tank, does heavy AoE damage.\n*3 Gemstone\n* Frost Blades\n* Snaring Blades"
];

function init () {
	if (isHost()) {
		addRule(Rule.NoMaxTerritoryExpand);
		addRule(Rule.AggressiveIA);
		addRule(Rule.ManyResources);
		addRule(Rule.IANeedColonize);
		addRule(Rule.NeedDefense);
		addRule(Rule.NoBurnBuilding);
		addRule(Rule.BifrostTower);
		addRule(Rule.AggressiveMyrkalfar);
		addRule(Rule.CantCloseAnimalDens);
		state.removeVictory(Victory.Fame);
		state.removeVictory(Victory.Lore);
		state.removeVictory(Victory.Money);
		state.removeVictory(Victory.Outsiders);
		state.removeVictory(Victory.Yggdrasil);
		state.removeVictory(Victory.OdinSword);
		state.removeVictory(Victory.Helheim);
		state.removeVictory(Victory.MealSquirrel);
		state.removeVictory(Victory.OwlTitanVic);
		me().objectives.add("stone", "Difficulty affects Economy, AI, Jungle & Waves\n\n[Stone] Difficulty - For New Players", {visible:true}, {name:"Stone", action: "setStone"});
		me().objectives.add("iron", "[Iron] Difficulty - For Experienced Players", {visible:true}, {name:"Iron", action: "setIron"});
		me().objectives.add("rimesteel", "[RimeSteel] Difficulty - For Veteran Players", {visible:true}, {name:"Rimesteel", action: "setRimesteel"});
		for (p in state.players) {
			if (p.isAI) p.setAILevel(5);
		}
	}
}

@sync function refreshOwners() {
	p1 = (getZone(206).owner == p1OG) ? p1OG : null;
	p2 = (getZone(121).owner == p2OG) ? p2OG : null;
	p3 = (getZone(29).owner == p3OG) ? p3OG : null;
	p4 = (getZone(277).owner == p4OG) ? p4OG : null;
	p5 = (getZone(196).owner == p5OG) ? p5OG : null;
	p6 = (getZone(100).owner == p6OG) ? p6OG : null;
}


function regularUpdate(dt: Float) {
	if (!isHost()) return;

	var currentTime = math.floor(state.time);

	if (currentTime == lastUpdateTime) return;
	lastUpdateTime = currentTime;

	var mod15 = currentTime % 15;
	var mod61 = currentTime % 61;
	var mod180 = currentTime % 180;
	var mod720 = currentTime % 720;

	@split[

		if (mod61 == 6) refreshOwners(),

		if (mod15 == 0 && currentTime >= 90) doWaveMovement(),

		if (mod61 == 5) doProgression(),

		if (mod180 == 93) spawnMonster(FoodCamp, 1),
		if (mod180 == 113) spawnMonster(WoodCamp, 2),
		if (mod180 == 133) spawnMonster(KrownsCamp, 3),
		if (mod180 == 153) spawnMonster(OresCamp, 4),

		if (mod180 == 3 && currentTime >= 90) doWaveSpawning(),

		if (mod720 == 7) spawnBoss(BossCamp),
	];
	if (mod15 == 1) pathCheck();

	if (state.time >= 15.0 && TeamBool == false) {
		TeamBool = true;
		setTeams();
	}
	if (currentTime == 1200) { clearObj(); }
}


function setTeams() {
	setAlly(p1, p2);
	setAlly(p1, p3);
	setAlly(p2, p3);
	setAlly(p4, p5);
	setAlly(p4, p6);
	setAlly(p5, p6);
	for (p in state.players) {
		p.genericNotify(
			"Minions spawn every 3 months\n" +
			"Build War-Camps for more Minions\n" +
			"Build economy behind townhall\n" +
			"First [Lore] picks your class:\n\n" +
			"TOP PATH = Defender\nMIDDLE PATH = Fighter\nBOTTOM PATH = Miner\n\n" +
			"Class upgrades by team [MilitaryXP]\n" +
			"4x Hero and 8x Bonus per class\n\n" +
			"Jungle spawn 3 month: \n[Food],[Wood],[Money],[Stone]\n" +
			"Boss spawn 12 month: \nTeam-Wide Buffs and Rewards"
		);
	}
}


@sync function doWaveMovement() {
	p1Wave = cleanWaveArray(p1Wave);
	p4Wave = cleanWaveArray(p4Wave);
	p2Wave = cleanWaveArray(p2Wave);
	p5Wave = cleanWaveArray(p5Wave);
	p3Wave = cleanWaveArray(p3Wave);
	p6Wave = cleanWaveArray(p6Wave);

	@split[
		sendWave(p1Wave, p1Attack, p1),
		sendWave(p4Wave, p4Attack, p4),
		sendWave(p2Wave, p2Attack, p2),
		sendWave(p5Wave, p5Attack, p5),
		sendWave(p3Wave, p3Attack, p3),
		sendWave(p6Wave, p6Attack, p6),
	];
}

@sync function clearObj() {
    me().objectives.setVisible("stone", false);
    me().objectives.setVisible("iron", false);
    me().objectives.setVisible("rimesteel", false);
}

@sync function setStone() {
    Difficulty = 1;
    state.difficulty = 1;
    clearObj();
    for (p in state.players) {
        p.addResource(Resource.Gemstone, 9);
        p.genericNotify("[Stone] Difficulty selected!\nThe game will be easy");
    }
}

@sync function setIron() {
    Difficulty = 2;
    state.difficulty = 2;
    clearObj();
    for (p in state.players) {
        p.addResource(Resource.Gemstone, 3);
        p.genericNotify("[Iron] Difficulty selected!\nThe game will be hard");
        if (p.isAI) {
            p.addBonus({ id: ConquestBonus.BPopGrowth, isAdvanced: false });
            p.addBonus({ id: ConquestBonus.BResBonus, resId: Resource.Food, isAdvanced: false });
            p.addBonus({ id: ConquestBonus.BResBonus, resId: Resource.Wood, isAdvanced: false });
            p.addBonus({ id: ConquestBonus.BResBonus, resId: Resource.Money, isAdvanced: false });
			p.addBonus({ id: ConquestBonus.BResBonus, resId: Resource.Lore, isAdvanced: false });
            p.addBonus({ id: ConquestBonus.BMineral, resId: Resource.Stone, isAdvanced: false });
            p.addBonus({ id: ConquestBonus.BWarband, isAdvanced: false });
        }
    }
}

@sync function setRimesteel() {
    Difficulty = 4;
    state.difficulty = 3;
    clearObj();
    for (p in state.players) {
		p.addResource(Resource.Gemstone, 1);
        p.genericNotify("[RimeSteel] Difficulty selected!\nThe game will be hardcore");
        if (p.isAI) {
            p.addBonus({ id: ConquestBonus.BPopGrowth, isAdvanced: true });
            p.addBonus({ id: ConquestBonus.BCaCTowers, isAdvanced: false });
            p.addBonus({ id: ConquestBonus.BNiflheimVampirism, isAdvanced: false });
            p.addBonus({ id: ConquestBonus.BResBonus, resId: Resource.Food, isAdvanced: true });
            p.addBonus({ id: ConquestBonus.BResBonus, resId: Resource.Wood, isAdvanced: true });
            p.addBonus({ id: ConquestBonus.BResBonus, resId: Resource.Money, isAdvanced: true });
			p.addBonus({ id: ConquestBonus.BResBonus, resId: Resource.Lore, isAdvanced: true });
            p.addBonus({ id: ConquestBonus.BMineral, resId: Resource.Stone, isAdvanced: true });
            p.addBonus({ id: ConquestBonus.BWarband, isAdvanced: true });
        }
    }
}


@sync function doProgression() {

	for (p in state.players) {
		if (p == null) continue;
		if (p.clan == Clan.Pack || p.clan == Clan.Lynx) {
			var isTeam1 = (p == p1OG || p == p2OG || p == p3OG);
			if (isTeam1) teamOneBonusXP += 120;
			else teamTwoBonusXP += 120;
		}
	}

	var teamOneXP = teamOneBonusXP;
	var teamTwoXP = teamTwoBonusXP;

	if (p1 != null) teamOneXP += p1.getResource(Resource.MilitaryXP);
	if (p2 != null) teamOneXP += p2.getResource(Resource.MilitaryXP);
	if (p3 != null) teamOneXP += p3.getResource(Resource.MilitaryXP);

	if (p4 != null) teamTwoXP += p4.getResource(Resource.MilitaryXP);
	if (p5 != null) teamTwoXP += p5.getResource(Resource.MilitaryXP);
	if (p6 != null) teamTwoXP += p6.getResource(Resource.MilitaryXP);

	var xpMult = if (Difficulty == 4) 1.5 else if (Difficulty == 2) 1.2 else 1.0;

	if (teamOneXP > (4000 * xpMult)) {
		teamOneLevel = teamOneXP > (25000 * xpMult) ? 4 : (teamOneXP > (10000 * xpMult) ? 3 : 2);
	}
	if (teamTwoXP > (4000 * xpMult)) {
		teamTwoLevel = teamTwoXP > (25000 * xpMult) ? 4 : (teamTwoXP > (10000 * xpMult) ? 3 : 2);
	}


	var level = math.max(teamOneLevel, teamTwoLevel);
	for (p in state.players) {
		if (p == null) continue;

		if (p.getResource(Resource.RimeSteel) > 0) {
			p.setResource(Resource.RimeSteel, 0);

			var isTeam1 = (p == p1OG || p == p2OG || p == p3OG);
			var team = isTeam1 ? [p1, p2, p3] : [p4, p5, p6];
			for (member in team) {
				if (member == null) continue;
				member.addResource(Resource.Gemstone, 3);
				member.addResource(Resource.Food, math.floor(level * 150));
				member.addResource(Resource.Wood, math.floor(level * 150));
				member.addResource(Resource.Money, math.floor(level * 150));
				member.addResource(Resource.MilitaryXP, math.floor(level * 150));
				member.genericNotify("Your team killed the Boss! You gain " + math.floor(level*150) + " [Food], [Wood], [Money], [MilitaryXP] and 3 [Gemstone]");
				}
			return;
		}
	}
}

@sync function pathCheck() {
	var upgraded = false;
    for (p in state.players) {
        if (p == null) continue;

        var zone = null;
        var th = p.getBuilding(Building.TownHall);
        if (th == null) th = p.getBuilding(Building.CarolingianTownHall);
        if (th == null) th = p.getBuilding(Building.CarolingianTownHallPop);
        if (th == null) th = p.getBuilding(Building.CarolingianTownHallMilitary);
        if (th == null) continue;

        zone = th.zone;
        if (zone == null) continue;

        var isTeam1 = (p == p1OG || p == p2OG || p == p3OG);
        var teamLevel = isTeam1 ? teamOneLevel : teamTwoLevel;

        if (teamLevel < 1 || teamLevel > 4) continue;

        var hasDefTech = (p.hasTech(Tech.Lumber) || p.hasTech(Tech.SimpleLiving) || p.hasTech(Tech.FertileSoils));
        var hasFightTech = (p.hasTech(Tech.Weaponsmith) || p.hasTech(Tech.Frenzy) || p.hasTech(Tech.MilitaryFunds) || p.hasTech(Tech.EndlessTide) || p.hasTech(Tech.KitchenNightmare) || p.hasTech(Tech.EnforcedEnrollment) || p.hasTech(Tech.InlandProtection) || p.hasTech(Tech.CarnivorousFlower) || p.hasTech(Tech.Bloodthirst) || p.hasTech(Tech.PrivateArmy));
        var hasMineTech = (p.hasTech(Tech.Mining) || p.hasTech(Tech.Excavation) || p.hasTech(Tech.GreatDeeds) || p.hasTech(Tech.WinterFestival) || p.hasTech(Tech.LayLayLand) || p.hasTech(Tech.Economics) || p.hasTech(Tech.ChainTasks) || p.hasTech(Tech.Scavenger) || p.hasTech(Tech.Landlords) || p.hasTech(Tech.MineralRoots) || p.hasTech(Tech.Characoal));

        var hasDefBonus = p.hasBonus(defenderBonuses1[0]);
        var hasFightBonus = p.hasBonus(attackerBonuses1[0]);
        var hasMineBonus = p.hasBonus(minerBonuses1[0]);

        if (hasDefTech && !hasFightBonus && !hasMineBonus) {
            if (!p.hasBonus(defenderBonuses1[teamLevel - 1])) {
                p.addBonus({ id: defenderBonuses1[teamLevel - 1], isAdvanced: false });
                p.addBonus({ id: defenderBonuses2[teamLevel - 1], isAdvanced: false });
                zone.addUnit(defenderUnits[teamLevel - 1], 1, p);
                p.genericNotify(defenderMessages[teamLevel - 1]);
				p.addResource(Resource.Gemstone, 3);
				upgraded = true;
            }
            continue;
        }

        if (hasFightTech && !hasDefBonus && !hasMineBonus) {
            if (!p.hasBonus(attackerBonuses1[teamLevel - 1])) {
                p.addBonus({ id: attackerBonuses1[teamLevel - 1], isAdvanced: false });
                p.addBonus({ id: attackerBonuses2[teamLevel - 1], isAdvanced: false });
                zone.addUnit(attackerUnits[teamLevel - 1], 1, p);
                p.genericNotify(attackerMessages[teamLevel - 1]);
				p.addResource(Resource.Gemstone, 3);
				upgraded = true;
            }
            continue;
        }

        if (hasMineTech && !hasDefBonus && !hasFightBonus) {
            if (!p.hasBonus(minerBonuses1[teamLevel - 1])) {
                p.addBonus({ id: minerBonuses1[teamLevel - 1], isAdvanced: false });
                p.addBonus({ id: minerBonuses2[teamLevel - 1], isAdvanced: false });
                zone.addUnit(minerUnits[teamLevel - 1], 1, p);
                p.genericNotify(minerMessages[teamLevel - 1]);
				p.addResource(Resource.Gemstone, 3);
				upgraded = true;
            }
            continue;
        }
    }
	if (upgraded) sfx(UiSfx.LeagueUp);
}


@sync function doWaveSpawning() {
	Wave++;
	sfx(UiSfx.Horn);

	var toKill = [];
	for (p in state.players) {
		if (p == null) continue;
		var dragons = p.getUnits(Unit.OldDragon);
		if (dragons != null) {
			for (unit in dragons) {
				if (unit != null) {
					var unitZone = unit.zone;
					if (unit.life <= 0.0 || unitZone == null || unitZone.owner == null || unitZone.owner == unit.owner) {
						toKill.push(unit);
					}
				}
			}
		}
		var cannons = p.getUnits(Unit.Hildegard);
		if (cannons != null) {
			for (unit in cannons) {
				if (unit != null) {
					var unitZone = unit.zone;
					if (unit.life <= 0.0 || unitZone == null || unitZone.owner == null || unitZone.owner == unit.owner) {
						toKill.push(unit);
					}
				}
			}
		}
	}
	for (unit in toKill) {
		if (unit != null) {
			unit.die(true);
		}
	}

	if (p1 != null && p4 != null && getZone(206).owner == p1 && getZone(277).owner == p4) {
		p1Wave = spawnWave(206, p1);
		p4Wave = spawnWave(277, p4);
	} else {
		p1Wave = [];
		p4Wave = [];
	}

	if (p2 != null && p5 != null && getZone(121).owner == p2 && getZone(196).owner == p5) {
		p2Wave = spawnWave(121, p2);
		p5Wave = spawnWave(196, p5);
	} else {
		p2Wave = [];
		p5Wave = [];
	}

	if (p3 != null && p6 != null && getZone(29).owner == p3 && getZone(100).owner == p6) {
		p3Wave = spawnWave(29, p3);
		p6Wave = spawnWave(100, p6);
	} else {
		p3Wave = [];
		p6Wave = [];
	}
}


@sync function cleanWaveArray(wave:Array<Unit>):Array<Unit> {
	if (wave == null || wave.length == 0) return [];

	var cleanedWave = [];
	for (unit in wave) {
		if (unit != null && unit.life > 0.0) {
			cleanedWave.push(unit);
		}
	}

	if (cleanedWave.length > 20) {
		for (i in 20...cleanedWave.length) {
			if (cleanedWave[i] != null) {
				cleanedWave[i].die(true);
			}
		}
		cleanedWave = cleanedWave.slice(0, 20);
	}

	return cleanedWave;
}



@sync function sendWave(wave:Array<Unit>, attackPath:Array<Zone>, owner):Void {
	if (wave == null || wave.length == 0 || owner == null || attackPath == null) {
		return;
	}

	var startIndex = -1;
	for (i in 0...attackPath.length) {
		if (attackPath[i].owner != owner && attackPath[i].owner != null) {
			startIndex = i;
			break;
		}
	}

	if (startIndex == -1) {
		launchAttack(wave, [attackPath[attackPath.length - 1].id]);
		return;
	}

	var path = [];
	for (i in startIndex...attackPath.length) {
		path.push(attackPath[i].id);
	}

	launchAttack(wave, path);
}


@sync function spawnWave(z:Int<Zone>, p:Player):Array<Unit> {
	if (p == null) return [];

	var TempArray = [];
	var maxWarband = p.getMax(Resource.Warband);
	var unitCount = 0;

	if (maxWarband < 15) {
		unitCount = 1 + math.floor(maxWarband/3);
		TempArray = getZone(z).addUnit(Unit.OldDragon, math.floor(unitCount), p);
		p.genericNotify("[Wave "+ Wave + "]: " + math.floor(unitCount) + "x Minions!\nBuild " + math.floor(((15-maxWarband)/2)) + " War-Camps for Cannons!");

	} else {
		unitCount = 1 + math.floor((maxWarband - 15) / 5);
		if (unitCount > 5) {
            unitCount = 5;
        }
		TempArray = getZone(z).addUnit(Unit.Hildegard, math.floor(unitCount), p);
		p.genericNotify("[WAVE "+ Wave + "]: " + math.floor(unitCount) + "x CANNONS!");

	}

	if (TempArray != null) {
		for (unit in TempArray) {
			if (unit != null) {
				unit.setUnitFlag(UnitFlag.DisableControl);
			}
		}
	}

	return TempArray;
}


@sync function spawnMonster(camps:Array<Zone>, type : Int) {
	var level = math.max(teamOneLevel, teamTwoLevel);
    var maxMonsters = math.min(Difficulty + 2, 5);

    for (zone in camps) {
        if (zone == null) continue;

        var counter = 0;
        var units = zone.units;
        if (units == null) continue;

        for (unit in units) {
            if (unit != null && unit.owner == null) {
                counter++;
            }
        }

        if (counter >= maxMonsters) continue;

        if (level == 1) {
            if (type == 1) zone.addUnit(Unit.Fox, 1, null);
            else if (type == 2) zone.addUnit(Unit.Death, 1, null);
            else if (type == 3) zone.addUnit(Unit.DwarfFoe, 1, null);
        } else if (level == 2) {
            if (type == 1) zone.addUnit(Unit.Wolf, 1, null);
            else if (type == 2) zone.addUnit(Unit.DwarfChampionFoe, 1, null);
            else if (type == 3) zone.addUnit(Unit.DwarfKingFoe, 1, null);
            else if (type == 4) zone.addUnit(Unit.SmallGolem, 1, null);
        } else if (level == 3) {
            if (type == 1) zone.addUnit(Unit.Bear, 1, null);
            else if (type == 2) zone.addUnit(Unit.Valkyrie, 1, null);
            else if (type == 3) zone.addUnit(Unit.UndeadGiant, 1, null);
            else if (type == 4) zone.addUnit(Unit.RimesteelGolem, 1, null);
        } else {
            if (type == 1) zone.addUnit(Unit.Boar, 1, null);
            else if (type == 2) zone.addUnit(Unit.IdavollValkyrie, 1, null);
            else if (type == 3) zone.addUnit(Unit.IceGolem, 1, null);
            else if (type == 4) zone.addUnit(Unit.WaveIronGolem, 1, null);
        }
    }
}


@sync function spawnBoss(camps:Array<Zone>) {
	var level = math.max(teamOneLevel, teamTwoLevel);
	sfx(UiSfx.GullveigWakeUp);
	if (Difficulty > 1) {
		for (p in state.players) {
			if (p.isAI) {
				p.addResource(Resource.Gemstone, math.floor((Difficulty*Difficulty*Difficulty)));
			}
		}
	}

	for (zone in camps) {
		if (zone == null) continue;

		var RandomNum = math.floor(math.random() * 3) + 1;

		var toKill = [];
		var units = zone.units;
		if (units != null) {
			for (unit in units) {
				if (unit != null && unit.owner == null) {
					toKill.push(unit);
				}
			}
		}
		for (unit in toKill) {
			if (unit != null) {
				unit.die(false);
			}
		}

		if (level == 1) {
			if (RandomNum == 1) {
				zone.addUnit(Unit.Giant, 1, null);
			} else if (RandomNum == 2) {
				zone.addUnit(Unit.Vanir, 1, null);
			} else if (RandomNum == 3) {
				zone.addUnit(Unit.ColossalBoar, 1, null);
			}
		} else if (level == 2) {
			if (RandomNum == 1) {
				var bossArray = zone.addUnit(Unit.GiantHero, 1, null);
				if (bossArray != null && bossArray.length > 0 && bossArray[0] != null) {
					bossArray[0].owner = null;
				}
			} else if (RandomNum == 2) {
				zone.addUnit(Unit.Golem, 1, null);
			} else if (RandomNum == 3) {
				var bossArray = zone.addUnit(Unit.GayantHero, 1, null);
				if (bossArray != null && bossArray.length > 0 && bossArray[0] != null) {
					bossArray[0].owner = null;
				}
			}
		} else {
			if (RandomNum == 1) {
				var bossArray = zone.addUnit(Unit.LichKing, 1, null);
				if (bossArray != null && bossArray.length > 0 && bossArray[0] != null) {
					bossArray[0].owner = null;
				}
			} else if (RandomNum == 2) {
				zone.addUnit(Unit.NidavellirIronGolem, 1, null);
			} else if (RandomNum == 3) {
				zone.addUnit(Unit.BabyWyvern, 1, null);
			}
		}
	}
}
