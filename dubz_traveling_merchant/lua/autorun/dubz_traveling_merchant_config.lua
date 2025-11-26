-- franks: global config for Franks Snow Packing
FranksSnowPacking = FranksSnowPacking or {}
FranksSnowPacking.Config = FranksSnowPacking.Config or {}

local CFG = FranksSnowPacking.Config

CFG.Pot = {
    Model    = "models/props_junk/terracotta01.mdl",
    GrowTime = 60,
}

CFG.Barrel = {
    Model       = "models/props_borealis/bluebarrel001.mdl",
    ProcessTime = 45,

    -- NEW: list of slosh sounds
    SloshSounds = {
        "player/footsteps/slosh1.wav",
        "player/footsteps/slosh2.wav",
        "player/footsteps/slosh3.wav",
        "player/footsteps/slosh4.wav",
    },
}

CFG.Chunks = {

    snow_chunk_small = {
        Model            = "models/grub_nugget_small.mdl",
        YieldValue       = 1,     -- How many bricks it counts as in processor logic
        PressesRequired  = 1,     -- How many presses the player must do
        Weight           = 4,     -- Higher = more common in processor output
    },

    snow_chunk_medium = {
        Model            = "models/grub_nugget_medium.mdl",
        YieldValue       = 2,
        PressesRequired  = 2,
        Weight           = 2,
    },

    snow_chunk_large = {
        Model            = "models/grub_nugget_large.mdl",
        YieldValue       = 3,
        PressesRequired  = 3,
        Weight           = 1,
    },
}

CFG.Processor = {
    Model       = "models/props_silo/processor_nobase.mdl",
    ProcessTime = 30,

    -- How many total “brick value” the processor spits out
    OutputValueMin = 4,
    OutputValueMax = 7,

    -- Sounds
    Sounds = {
        -- When you insert the bucket
        Start = "ambient/machines/steam_release_1.wav",

        -- Played continuously during processing
        Loop = "ambient/machines/machine4.wav",

        -- When the machine finishes processing
        End = "ambient/machines/steam_release_2.wav",

        -- Random metal clunks inside the mixer
        Clunks = {
            "physics/metal/metal_solid_impact_hard3.wav",
            "physics/metal/metal_solid_impact_hard4.wav",
            "physics/metal/metal_solid_impact_hard5.wav",
            "physics/metal/metal_barrel_impact_hard3.wav",
        },

        -- Random pressure vent bursts during processing
        Pressure = {
            "ambient/steam/steam_release_1.wav",
            "ambient/steam/steam_release_3.wav",
            "ambient/machines/steam_burst1.wav",
        },

        -- Short crackles and pops on shutdown
        ShutdownCrackle = {
            "ambient/energy/spark5.wav",
            "ambient/energy/spark6.wav",
            "ambient/energy/spark7.wav",
        },

        -- When chunks pop out onto the ground
        ChunkThunk = {
            "physics/body/body_medium_impact_soft1.wav",
            "physics/body/body_medium_impact_soft2.wav",
            "physics/concrete/concrete_impact_soft2.wav",
        },
    }
}

CFG.Seed = { Model = "models/spitball_small.mdl" }
CFG.Gas  = { Model = "models/props_junk/metalgascan.mdl" }
CFG.Acid = { Model = "models/props_junk/garbage_plasticbottle001a.mdl" }

CFG.Bucket = {
    Model    = "models/dav0r/tnt/tnt.mdl",
    Material = "models/props_debris/concretefloor020a",
    Color    = Color(175, 220, 130),
}

CFG.Crate = {
    ModelEmpty = "models/props_junk/cardboard_box001a.mdl",
    ModelFull  = "models/props_junk/cardboard_box001a.mdl",
    MaxStored  = 10,
}

CFG.MoneyBrick = {
    Model    = "models/props/cs_assault/Money.mdl",
    Material = "models/XQM/Rails/gumball_1",
}

CFG.Buyer = {
    -- Models & names
    Models = {
        "models/Humans/Group03/male_01.mdl",
        "models/Humans/Group03/male_02.mdl",
        "models/Humans/Group03/male_03.mdl",
        "models/Humans/Group03/male_04.mdl",
        "models/Humans/Group03/male_05.mdl",
        "models/Humans/Group03/male_06.mdl",
        "models/Humans/Group03/male_07.mdl",
        "models/Humans/Group03/male_08.mdl",
        "models/Humans/Group03/male_09.mdl"
    },

    Names = {
        "Tyrone", "Jamal", "Rashawn", "Tavon", "Quan", "Darnell",
        "Shaquan", "Rico", "Luis", "Jose", "Juan", "Felipe",
        "Sergio", "Andres", "Jamir"
    },

    -- Price config
    MinSellPrice     = 500,
    MaxSellPrice     = 1500,
    PriceRefreshTime = 120,   -- seconds between price changes

    -- Conversation / personality
    Dialogue = {
        Greet = {
            "Yo, what’s good?",
            "You lookin’ to move some snow or what?",
            "Aight, step up, talk to me.",
            "You got bricks for me or you just window shoppin’?"
        },
        Idle = {
            "Man, this block been dry all day...",
            "Keep it low, cops been circlin’ round here.",
            "Prices changin’ every hour, you better catch it while it’s hot.",
            "You see anyone lookin’ funny, you tell me, aight?",
            "Money talk, everything else whisper."
        },
        AfterSell = {
            "Good lookin’, I’ll move that.",
            "Aight, that’s a nice little flip for you.",
            "Come back when you got more weight.",
            "See? Told you this hustle pay off."
        },
        HighPrice = {
            "Snow hot right now, I’m tellin’ you.",
            "Today’s price ain’t yesterday’s price, feel me?",
            "These fiends payin’ stupid numbers out here."
        },
        LowPrice = {
            "Price kinda weak today, but it’s still money.",
            "Catch it while it’s low, flip more, make more.",
            "I ain’t happy with this rate either, but it is what it is."
        }
    },

    -- Voice line sounds
    Voice = {
        Sounds = {
            "vo/npc/male01/hi01.wav",
            "vo/npc/male01/hi02.wav",
            "vo/npc/male01/ok01.wav",
            "vo/npc/male01/ok02.wav",
            "vo/npc/male01/question23.wav",
            "vo/npc/male01/yeah02.wav",
            "vo/npc/male01/question06.wav"
        },
        Volume = 70,
        PitchMin = 90,
        PitchMax = 110
    },

    -- Smoking behavior
    Smoking = {
        Enabled      = true,
        Model        = "models/props/cs_militia/cigarette.mdl",
        IntervalMin  = 12,
        IntervalMax  = 25,
        InhaleSound  = "ambient/fire/ignite.wav",
        Gesture      = ACT_IDLE_RELAXED
    },

    -- Idle gestures
    Gestures = {
        Enabled      = true,
        IntervalMin  = 4,
        IntervalMax  = 9,
        Pool = {
            ACT_IDLE_RELAXED,
            ACT_IDLE_ANGRY,
            ACT_IDLE,
            ACT_SIGNAL_HALT,
            ACT_SIGNAL_GROUP,
            ACT_GESTURE_MELEE_SHOVE_1HAND,
            ACT_GMOD_TAUNT_MUSCLE
        }
    },

    -- Head tracking / awareness
    Awareness = {
        LookRange             = 350, -- units
        IdleLookAround        = true,
        LookAroundIntervalMin = 3,
        LookAroundIntervalMax = 6
    }
}