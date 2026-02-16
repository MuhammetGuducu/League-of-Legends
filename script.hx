var Wave = 0;

var lastUpdateTime = -1;

var Stag = getZone(206).owner;
var Wolf = getZone(121).owner;
var Goat = getZone(29).owner;
var Bear = getZone(277).owner;
var Dragon = getZone(196).owner;
var Horse = getZone(100).owner;

var StagAttack:Array<Zone> = [getZone(208), getZone(220), getZone(232), getZone(237), getZone(248), getZone(260), getZone(267), getZone(277)];
var BearAttack:Array<Zone> = [getZone(267), getZone(260), getZone(248), getZone(237), getZone(232), getZone(220), getZone(208), getZone(206)];

var WolfAttack:Array<Zone> = [getZone(130), getZone(135), getZone(147), getZone(155), getZone(169), getZone(178), getZone(185), getZone(196)];
var DragonAttack:Array<Zone> = [getZone(185), getZone(178), getZone(169), getZone(155), getZone(147), getZone(135), getZone(130), getZone(121)];

var GoatAttack:Array<Zone> = [getZone(43), getZone(51), getZone(62), getZone(64), getZone(73), getZone(84), getZone(93), getZone(100)];
var HorseAttack:Array<Zone> = [getZone(93), getZone(84), getZone(73), getZone(64), getZone(62), getZone(51), getZone(43), getZone(29)];


var StagWave:Array<Unit> = [];
var WolfWave:Array<Unit> = [];
var GoatWave:Array<Unit> = [];
var BearWave:Array<Unit> = [];
var DragonWave:Array<Unit> = [];
var HorseWave:Array<Unit> = [];


var FoodCamp:Array<Zone> = [getZone(165), getZone(219), getZone(139), getZone(88)];
var WoodCamp:Array<Zone> = [getZone(212), getZone(132), getZone(94), getZone(171)];
var KrownsCamp:Array<Zone> = [getZone(184), getZone(106), getZone(124), getZone(202)];
var OresCamp:Array<Zone> = [getZone(193), getZone(113)];
var BossCamp:Array<Zone> = [getZone(166), getZone(136)];

var teamOneLevel = 1;
var teamTwoLevel = 1;

var minerUnits = [Unit.DwarfChampion, Unit.HorseMaiden, Unit.HippogriffHero];
var minerBonuses1 = [ConquestBonus.BForgeRelics, ConquestBonus.BColonizeCost, ConquestBonus.BHousePopulation];
var minerBonuses2 = [ConquestBonus.BWinter, ConquestBonus.BSilo, ConquestBonus.BPopGrowth];
var minerMessages = [
    "[MINER Lv.1]: [DwarfChampion]. Slow miner and smith.\n-50% [Relic] cost and time and -30% Winter Severity",
    "[MINER Lv.2]: [HorseMaiden]. Moderate miner and smith, can fight outside your territory.\n-30% Colonze Cost + 20% Silo bonus",
    "[MINER Lv.3]: [HippogriffHero]. Fast miner and smith, can fight and mine outside your territory.\n+2 House space + 60% [Population] Growth"
];

var attackerUnits = [Unit.Berserker, Unit.Berserker03, Unit.EagleHero];
var attackerBonuses1 = [ConquestBonus.BUnitFree, ConquestBonus.BNiflheimVampirism, ConquestBonus.BNidavellirDoTUnit];
var attackerBonuses2 = [ConquestBonus.BWarband, ConquestBonus.BWarchiefCooldown, ConquestBonus.BVanaheimRootUnit];
var attackerMessages = [
    "[FIGHTER Lv.1]: [Berserker]. High damage, low defense.\n3 Free Units + 3 Free [Warband]",
    "[FIGHTER Lv.2]: [Berserker03]. Bigger brother of the Berserker.\nUnits gain Lifesteal + 50% Warchief Cooldown Reduction",
    "[FIGHTER Lv.3]: [EagleHero]. Swift assassin with ranged attacks.\nPoison Blades + Snaring Blades"
];

var defenderUnits = [Unit.BearMaiden, Unit.TurtleHero, Unit.RatMaiden];
var defenderBonuses1 = [ConquestBonus.BRuinsExploration, ConquestBonus.BTowerMultiShot, ConquestBonus.BMultipleTowers];
var defenderBonuses2 = [ConquestBonus.BColonizeCost, ConquestBonus.BExplodingTowers, ConquestBonus.BTowerMultiTarget];
var defenderMessages = [
    "[DEFENDER Lv.1]: [BearMaiden]. Slow tank, fishes for food, regenerates health.\n-30% Colonize Cost + Ruins yield 2x resources",
    "[DEFENDER Lv.2]: [TurtleHero]. Durable tank, reduces upgrade and purchase costs.\nTowers shoot two arrows + Exploding Towers",
    "[DEFENDER Lv.3]: [RatMaiden]. Strong tank, heals all allies in the zone.\nBuild two towers per zone + Towers target 3 enemies"
];

function init () {
	if (isHost()) {
		for (player in state.players) {
			if (player.isAI) {
				player.addBonus({ id: ConquestBonus.BCaCTowers, isAdvanced: false });
				player.addBonus({ id: ConquestBonus.BPopGrowth, isAdvanced: true });
				player.addBonus({ id: ConquestBonus.BResBonus, resId:Resource.Food, isAdvanced: true });
				player.addBonus({ id: ConquestBonus.BResBonus, resId:Resource.Wood, isAdvanced: false });
				player.addBonus({ id: ConquestBonus.BResBonus, resId:Resource.Money, isAdvanced: false });
				player.addBonus({ id: ConquestBonus.BMineral, resId:Resource.Stone, isAdvanced: false });
				player.setAILevel(5);
				player.addResource(Resource.Gemstone, 40);
			} else {
				player.addBonus({ id: ConquestBonus.BCaCTowers, isAdvanced: false });
			}
		}
		state.difficulty = 3;
		state.removeVictory(Victory.Fame);
		state.removeVictory(Victory.Lore);
		state.removeVictory(Victory.Money);
		state.removeVictory(Victory.Outsiders);
		state.removeVictory(Victory.Yggdrasil);
		state.removeVictory(Victory.OdinSword);
		state.removeVictory(Victory.Helheim);
		state.removeVictory(Victory.MealSquirrel);
		state.removeVictory(Victory.OwlTitanVic);
		addRule(Rule.NoMaxTerritoryExpand);
		addRule(Rule.AggressiveIA);
		addRule(Rule.ManyResources);
		addRule(Rule.IANeedColonize);
		addRule(Rule.NeedDefense);
		addRule(Rule.AggressiveMyrkalfar);
		addRule(Rule.CantCloseAnimalDens);
	}
}


@sync function refreshOwners() {
	Stag = getZone(206).owner;
	Wolf = getZone(121).owner;
	Goat = getZone(29).owner;
	Bear = getZone(277).owner;
	Dragon = getZone(196).owner;
	Horse = getZone(100).owner;
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
		refreshOwners(),

		if (mod15 == 0) doWaveMovement(),

		if (mod61 == 5) doProgression(),

		if (mod180 == 93) spawnMonster(FoodCamp, 1),
		if (mod180 == 113) spawnMonster(WoodCamp, 2),
		if (mod180 == 133) spawnMonster(KrownsCamp, 3),
		if (mod180 == 153) spawnMonster(OresCamp, 4),

		if (mod180 == 3) doWaveSpawning(),

		if (mod720 == 7) spawnBoss(BossCamp),
	];
	if (mod15 == 1) pathCheck();
}


@sync function doWaveMovement() {
	StagWave = cleanWaveArray(StagWave);
	BearWave = cleanWaveArray(BearWave);
	WolfWave = cleanWaveArray(WolfWave);
	DragonWave = cleanWaveArray(DragonWave);
	GoatWave = cleanWaveArray(GoatWave);
	HorseWave = cleanWaveArray(HorseWave);

	@split[
		sendWave(StagWave, StagAttack, Stag),
		sendWave(BearWave, BearAttack, Bear),
		sendWave(WolfWave, WolfAttack, Wolf),
		sendWave(DragonWave, DragonAttack, Dragon),
		sendWave(GoatWave, GoatAttack, Goat),
		sendWave(HorseWave, HorseAttack, Horse),
	];
}


@sync function doProgression() {
	var teamOneXP = 0.0;
	var teamTwoXP = 0.0;

	if (Stag != null) teamOneXP += Stag.getResource(Resource.MilitaryXP);
	if (Wolf != null) teamOneXP += Wolf.getResource(Resource.MilitaryXP);
	if (Goat != null) teamOneXP += Goat.getResource(Resource.MilitaryXP);

	if (Bear != null) teamTwoXP += Bear.getResource(Resource.MilitaryXP);
	if (Dragon != null) teamTwoXP += Dragon.getResource(Resource.MilitaryXP);
	if (Horse != null) teamTwoXP += Horse.getResource(Resource.MilitaryXP);

	if (teamOneXP > 4000) {
		teamOneLevel = teamOneXP > 10000 ? 3 : 2;
	}
	if (teamTwoXP > 4000) {
		teamTwoLevel = teamTwoXP > 10000 ? 3 : 2;
	}

	var level = math.max(teamOneLevel, teamTwoLevel);

	for (p in state.players) {
		if (p == null) continue;

		if (p.getResource(Resource.RimeSteel) > 0) {
			p.setResource(Resource.RimeSteel, 0);



			var isTeam1 = (p.clan == Clan.Wolf || p.clan == Clan.Stag || p.clan == Clan.Goat);
			var team = isTeam1 ? [Wolf, Stag, Goat] : [Horse, Dragon, Bear];

			for (member in team) {
				if (member == null) continue;

				member.addResource(Resource.Gemstone, level);
				member.addResource(Resource.Fame, level*50);
				member.addResource(Resource.Lore, level*200);
				member.genericNotify("Your team killed the Boss! You gain " + level*200 + " [Lore], " + level*50 + " [Fame], " + level + " [Gemstone]");
			}
			return;
		}
	}
}

@sync function pathCheck() {
    for (p in state.players) {
        if (p == null) continue;

        var zone = p.getBuilding(Building.TownHall).zone;
        if (zone == null) continue;

        var isTeam1 = (p.clan == Clan.Stag || p.clan == Clan.Wolf || p.clan == Clan.Goat);
        var teamLevel = isTeam1 ? teamOneLevel : teamTwoLevel;

        if (teamLevel < 1 || teamLevel > 3) continue;

        if (p.hasTech(Tech.Lumber) && !p.hasBonus(attackerBonuses1[0]) && !p.hasBonus(minerBonuses1[0])) {
            if (!p.hasBonus(defenderBonuses1[teamLevel - 1])) {
                p.addBonus({ id: defenderBonuses1[teamLevel - 1], isAdvanced: false });
                p.addBonus({ id: defenderBonuses2[teamLevel - 1], isAdvanced: false });
                zone.addUnit(defenderUnits[teamLevel - 1], 1, p);
                p.genericNotify(defenderMessages[teamLevel - 1]);
            }
            continue;
        }

        if ((p.hasTech(Tech.Weaponsmith) || p.hasTech(Tech.Frenzy)) && !p.hasBonus(defenderBonuses1[0]) && !p.hasBonus(minerBonuses1[0])) {
            if (!p.hasBonus(attackerBonuses1[teamLevel - 1])) {
                p.addBonus({ id: attackerBonuses1[teamLevel - 1], isAdvanced: false });
                p.addBonus({ id: attackerBonuses2[teamLevel - 1], isAdvanced: false });
                zone.addUnit(attackerUnits[teamLevel - 1], 1, p);
                p.genericNotify(attackerMessages[teamLevel - 1]);
            }
            continue;
        }

        if ((p.hasTech(Tech.Mining) || p.hasTech(Tech.Excavation) || p.hasTech(Tech.GreatDeeds) || p.hasTech(Tech.WinterFestival)) && !p.hasBonus(defenderBonuses1[0]) && !p.hasBonus(attackerBonuses1[0])) {
            if (!p.hasBonus(minerBonuses1[teamLevel - 1])) {
                p.addBonus({ id: minerBonuses1[teamLevel - 1], isAdvanced: false });
                p.addBonus({ id: minerBonuses2[teamLevel - 1], isAdvanced: false });
                zone.addUnit(minerUnits[teamLevel - 1], 1, p);
                p.genericNotify(minerMessages[teamLevel - 1]);
            }
            continue;
        }
    }
}


@sync function doWaveSpawning() {
	Wave++;
	sfx(UiSfx.Horn);

	var toKill = [];
	for (p in state.players) {
		if (p == null) continue;
		var mercs = p.getUnits(Unit.Mercenary);
		if (mercs != null) {
			for (unit in mercs) {
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

	// Only spawn waves if BOTH players in a lane are alive (non-null).
	if (Stag != null && Bear != null && getZone(206).owner == Stag && getZone(277).owner == Bear) {
		StagWave = spawnWave(206, Stag);
		BearWave = spawnWave(277, Bear);
	} else {
		StagWave = [];
		BearWave = [];
	}

	if (Wolf != null && Dragon != null && getZone(121).owner == Wolf && getZone(196).owner == Dragon) {
		WolfWave = spawnWave(121, Wolf);
		DragonWave = spawnWave(196, Dragon);
	} else {
		WolfWave = [];
		DragonWave = [];
	}

	if (Goat != null && Horse != null && getZone(29).owner == Goat && getZone(100).owner == Horse) {
		GoatWave = spawnWave(29, Goat);
		HorseWave = spawnWave(100, Horse);
	} else {
		GoatWave = [];
		HorseWave = [];
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
	var unitCount = 0;

	if (Wave % 3 != 0) {
		unitCount = math.floor(math.max(teamOneLevel, teamTwoLevel));
		TempArray = getZone(z).addUnit(Unit.Mercenary, unitCount, p);
		p.genericNotify("[Wave "+ Wave + "]: " + unitCount + "x Minions have spawned!");
	} else {
		unitCount = math.floor(math.max(teamOneLevel, teamTwoLevel)*2);
		TempArray = getZone(z).addUnit(Unit.Mercenary, unitCount, p);
		p.genericNotify("[MEGA WAVE "+ Wave + "]: " + unitCount + "x Minions have spawned!");
		shakeCamera(false);
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

		if (counter >= 3) continue;

		if (level == 1) {
			if (type == 1) zone.addUnit(Unit.SpecterWarrior, 1, null);
			else if (type == 2) zone.addUnit(Unit.Lightalfar, 1, null);
			else if (type == 3) zone.addUnit(Unit.DwarfFoe, 1, null);
		} else if (level == 2) {
			if (type == 1) zone.addUnit(Unit.IdavollValkyrie, 1, null);
			else if (type == 2) zone.addUnit(Unit.DwarfChampionFoe, 1, null);
			else if (type == 3) zone.addUnit(Unit.DwarfKingFoe, 1, null);
			else if (type == 4) zone.addUnit(Unit.SmallGolem, 1, null);
		} else {
			if (type == 1) zone.addUnit(Unit.IceGolem, 1, null);
			else if (type == 2) zone.addUnit(Unit.Valkyrie, 1, null);
			else if (type == 3) zone.addUnit(Unit.UndeadGiant, 1, null);
			else if (type == 4) zone.addUnit(Unit.RimesteelGolem, 1, null);
		}
	}
}


@sync function spawnBoss(camps:Array<Zone>) {
	var level = math.max(teamOneLevel, teamTwoLevel);

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
				zone.addUnit(Unit.NidavellirIronGolem, 1, null);
			}
		} else {
			if (RandomNum == 1) {
				var bossArray = zone.addUnit(Unit.LichKing, 1, null);
				if (bossArray != null && bossArray.length > 0 && bossArray[0] != null) {
					bossArray[0].owner = null;
				}
			} else if (RandomNum == 2) {
				zone.addUnit(Unit.Dracula, 1, null);
			} else if (RandomNum == 3) {
				zone.addUnit(Unit.BabyWyvern, 1, null);
			}
		}
	}
}
