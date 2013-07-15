--/////////////////////////////////////////          ----FEATURE LIST----            ///////////////////////////////////////////--
--////                                                                                                                      ////--
--////                                        No need to manually resource.AddFile                                          ////--
--////                                                                                                                      ////--
--////                       Three tables to add the different sounds to the different type of wins.                        ////--
--////                                                                                                                      ////--
--////        No need to add "sound/" in the tables, if you do, you'll actually be screwing up the resource.addfile         ////--
--////                                                                                                                      ////--
--////                     Sounds are randomly chosen inside the table matching the proper win method                       ////--
--////                                                                                                                      ////--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

--/////////////////////////////////////////        ----WARNINGS AND TIPS----         ///////////////////////////////////////////--
--////                                                                                                                      ////--
--////                                   Remember that you can only use "/" and not "\"                                     ////--
--////                                                                                                                      ////--
--//// Remember to keep a table actually not fully empty to avoid code breaking. You can even just leave a wrong path in it ////--
--////                                                                                                                      ////--
--////                             For a guide on how to add new sounds, check the workshop page                            ////--
--////                                                                                                                      ////--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

-- Sounds played when the innocent win
local InnocentWinSounds = {
"new_prime/music/version1/animalihavebecome.mp3",
"new_prime/music/version1/anonymous.mp3",
"new_prime/music/version1/bittertaste.mp3",
"new_prime/music/version1/blackbetty.mp3",
"new_prime/music/version1/bloodonmyhands.mp3",
"new_prime/music/version1/bloodsugar.mp3",
"new_prime/music/version1/chalkoutline.mp3",
"new_prime/music/version1/comininhot.mp3",
"new_prime/music/version1/crush.mp3",
"new_prime/music/version1/cyanidesweettoothsuicide.mp3",
"new_prime/music/version1/danicalifornia.mp3",
"new_prime/music/version1/diamondintherough.mp3",
"new_prime/music/version1/drfeelgood.mp3",
"new_prime/music/version1/endoftheworld.mp3",
"new_prime/music/version1/enemies.mp3",
"new_prime/music/version1/fightforyourright.mp3",
"new_prime/music/version1/headabovewater.mp3",
"new_prime/music/version1/immigrantsong.mp3",
"new_prime/music/version1/justdontcareanymore.mp3",
"new_prime/music/version1/kickstartmyheart.mp3",
"new_prime/music/version1/letthereberock.mp3",
"new_prime/music/version1/liveitup.mp3",
"new_prime/music/version1/loadedandalone.mp3",
"new_prime/music/version1/monster.mp3",
"new_prime/music/version1/mysharona.mp3",
"new_prime/music/version1/noonefitsme.mp3",
"new_prime/music/version1/nowherekids.mp3",
"new_prime/music/version1/readytorock.mp3",
"new_prime/music/version1/runninwild.mp3",
"new_prime/music/version1/showdown.mp3",
"new_prime/music/version1/sinwithagrin.mp3",
"new_prime/music/version1/smellsliketeenspirit.mp3",
"new_prime/music/version1/soundofmadness.mp3",
"new_prime/music/version1/thepretender.mp3",
"new_prime/music/version1/thetempest.mp3",
"new_prime/music/version1/toomuchtooyoungtoofast.mp3",
"new_prime/music/version1/unbreakableheart.mp3",
"new_prime/music/version1/unity.mp3",
"new_prime/music/version1/watercolour.mp3",
"new_prime/music/version1/witchcraft.mp3",
"new_prime/music/version1/youarethewilderness.mp3",
"new_prime/music/version1/youthinkiaintworthadollarbutifeellikeamillionaire.mp3"
}

-- Sounds played when the traitors win
local TraitorWinSounds = {
"new_prime/music/version1/animalihavebecome.mp3",
"new_prime/music/version1/anonymous.mp3",
"new_prime/music/version1/bittertaste.mp3",
"new_prime/music/version1/blackbetty.mp3",
"new_prime/music/version1/bloodonmyhands.mp3",
"new_prime/music/version1/bloodsugar.mp3",
"new_prime/music/version1/chalkoutline.mp3",
"new_prime/music/version1/comininhot.mp3",
"new_prime/music/version1/crush.mp3",
"new_prime/music/version1/cyanidesweettoothsuicide.mp3",
"new_prime/music/version1/danicalifornia.mp3",
"new_prime/music/version1/diamondintherough.mp3",
"new_prime/music/version1/drfeelgood.mp3",
"new_prime/music/version1/endoftheworld.mp3",
"new_prime/music/version1/enemies.mp3",
"new_prime/music/version1/fightforyourright.mp3",
"new_prime/music/version1/headabovewater.mp3",
"new_prime/music/version1/immigrantsong.mp3",
"new_prime/music/version1/justdontcareanymore.mp3",
"new_prime/music/version1/kickstartmyheart.mp3",
"new_prime/music/version1/letthereberock.mp3",
"new_prime/music/version1/liveitup.mp3",
"new_prime/music/version1/loadedandalone.mp3",
"new_prime/music/version1/monster.mp3",
"new_prime/music/version1/mysharona.mp3",
"new_prime/music/version1/noonefitsme.mp3",
"new_prime/music/version1/nowherekids.mp3",
"new_prime/music/version1/readytorock.mp3",
"new_prime/music/version1/runninwild.mp3",
"new_prime/music/version1/showdown.mp3",
"new_prime/music/version1/sinwithagrin.mp3",
"new_prime/music/version1/smellsliketeenspirit.mp3",
"new_prime/music/version1/soundofmadness.mp3",
"new_prime/music/version1/thepretender.mp3",
"new_prime/music/version1/thetempest.mp3",
"new_prime/music/version1/toomuchtooyoungtoofast.mp3",
"new_prime/music/version1/unbreakableheart.mp3",
"new_prime/music/version1/unity.mp3",
"new_prime/music/version1/watercolour.mp3",
"new_prime/music/version1/witchcraft.mp3",
"new_prime/music/version1/youarethewilderness.mp3",
"new_prime/music/version1/youthinkiaintworthadollarbutifeellikeamillionaire.mp3"
}

-- Sounds played when time is up
local OutOfTimeSounds = {
"new_prime/music/version1/animalihavebecome.mp3",
"new_prime/music/version1/anonymous.mp3",
"new_prime/music/version1/bittertaste.mp3",
"new_prime/music/version1/blackbetty.mp3",
"new_prime/music/version1/bloodonmyhands.mp3",
"new_prime/music/version1/bloodsugar.mp3",
"new_prime/music/version1/chalkoutline.mp3",
"new_prime/music/version1/comininhot.mp3",
"new_prime/music/version1/crush.mp3",
"new_prime/music/version1/cyanidesweettoothsuicide.mp3",
"new_prime/music/version1/danicalifornia.mp3",
"new_prime/music/version1/diamondintherough.mp3",
"new_prime/music/version1/drfeelgood.mp3",
"new_prime/music/version1/endoftheworld.mp3",
"new_prime/music/version1/enemies.mp3",
"new_prime/music/version1/fightforyourright.mp3",
"new_prime/music/version1/headabovewater.mp3",
"new_prime/music/version1/immigrantsong.mp3",
"new_prime/music/version1/justdontcareanymore.mp3",
"new_prime/music/version1/kickstartmyheart.mp3",
"new_prime/music/version1/letthereberock.mp3",
"new_prime/music/version1/liveitup.mp3",
"new_prime/music/version1/loadedandalone.mp3",
"new_prime/music/version1/monster.mp3",
"new_prime/music/version1/mysharona.mp3",
"new_prime/music/version1/noonefitsme.mp3",
"new_prime/music/version1/nowherekids.mp3",
"new_prime/music/version1/readytorock.mp3",
"new_prime/music/version1/runninwild.mp3",
"new_prime/music/version1/showdown.mp3",
"new_prime/music/version1/sinwithagrin.mp3",
"new_prime/music/version1/smellsliketeenspirit.mp3",
"new_prime/music/version1/soundofmadness.mp3",
"new_prime/music/version1/thepretender.mp3",
"new_prime/music/version1/thetempest.mp3",
"new_prime/music/version1/toomuchtooyoungtoofast.mp3",
"new_prime/music/version1/unbreakableheart.mp3",
"new_prime/music/version1/unity.mp3",
"new_prime/music/version1/watercolour.mp3",
"new_prime/music/version1/witchcraft.mp3",
"new_prime/music/version1/youarethewilderness.mp3",
"new_prime/music/version1/youthinkiaintworthadollarbutifeellikeamillionaire.mp3"
}

for k, v in pairs (InnocentWinSounds) do
	resource.AddFile("sound/"..v)
	util.PrecacheSound("sound/"..v)
end

for k, v in pairs (TraitorWinSounds) do
	resource.AddFile("sound/"..v)
	util.PrecacheSound("sound/"..v)
end

for k, v in pairs (OutOfTimeSounds) do
	resource.AddFile("sound/"..v)
	util.PrecacheSound("sound/"..v)
end

local function PlaySoundClip(win)
	if win == WIN_INNOCENT then
		BroadcastLua('surface.PlaySound("'..InnocentWinSounds[math.random(1, #InnocentWinSounds)]..'")')
	elseif win == WIN_TRAITOR then
		BroadcastLua('surface.PlaySound("'..TraitorWinSounds[math.random(1, #TraitorWinSounds)]..'")')
	elseif win == WIN_TIMELIMIT then
		BroadcastLua('surface.PlaySound("'..OutOfTimeSounds[math.random(1, #OutOfTimeSounds)]..'")')
	end
end
hook.Add("TTTEndRound", "SoundClipEndRound", PlaySoundClip)