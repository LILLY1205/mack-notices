Config = {}

Config.Zones = {
    -- Town Hall - Val
    {
        name = "Town Hall",
        coords = vector3(-362.52, 811.66, 116.89),
        distance = 10.0,
        messages = {
            "Welcome to the Main Dutton County Town Hall",
            "Get your Homes, Jobs and Licences",
            "Licenses are required for Saloon, Stores and",
            "Getting Married"
        },
        lastShown = 0,
        cooldown = 5000 -- Cooldown between notifications in ms
    },
    -- Valentine Saloon Val
    {
        name = "Macks Salooon",
        coords = vector3(-311.55, 805.96, 118.98),
        distance = 10.0,
        messages = {
            "For Self Service Pree ALT on the Bar to See Menu",
            "If a Member of the Bar staff are here then",
            "Just ask and they will Serve your.",
            "Stress relief upstairs, and Danecer",
            "We have Poker and Roulette",
            "On the stairs, Feel Free to Relax"
        },
        lastShown = 0,
        cooldown = 5000
    },
    -- Law Offices
    {
        name = "The Law",
        coords = vector3(-276.57, 800.45, 119.36),
        distance = 10.0,
        messages = {
            "Your Marshal is Jessie James",
            "No Fire Arms to be in HAND within town Limts",
            "A Duel Can be Called, If Witnesses",
            "Report All and Any Crimes to the Law Officers",
            "Stop and Searchs are Allowed in Valentine"
        },
        lastShown = 0,
        cooldown = 5000
    },
    -- Bank Val
    {
        name = "The Bank",
        coords = vector3(-308.29, 779.86, 118.73),
        distance = 10.0,
        messages = {
            "Wages are paid to St Denis Bank",
            "Money Clips Can be Made inside.",
            "Gold Dealer is on your Left.",
            "Each Bank is speterate",
            "Have a Great Day !"
        },
        lastShown = 0,
        cooldown = 5000
    }
}

-- Notification Settings
Config.NotificationSettings = {
    duration = 6000, -- 6 seconds notification display time
    placement = 'middle-left',
    icon = 'warning'
}