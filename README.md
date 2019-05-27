# Panacea Drums

This addon was based on [ccDrums](https://www.wowinterface.com/downloads/info9801-ccDrums.html) by ccKep, which was then slightly modified by Tsunadee from the WoW guild Panacea.

Requires World of Warcraft - The Burning Crusade! (TBC 2.4.3)

**Download: [PanaceaDrums-master.zip](https://github.com/VideoPlayerCode/PanaceaDrums/archive/master.zip)** (Put the inner "Panacea_Drums" folder into your WoW's "Interface/AddOns" folder.)

## What this addon can do:

- Set up a rotation for each drum within the group with a simple command BEFORE the pull.
- Synchronize everyone's rotation each time someone uses a drum, even if not in range.
- Adapt to a rotation change when people are dead, offline, or changing group. (For example, it automatically skips dead/offline players.)
- Adapt to a rotation change when someone takes someone else's order (by using their drum too early).
- Whisper the next one on the list automatically. No need for manual macros that will change all the time!
- Play a sound effect when it's your turn to drum. No need to check party text or whispers anymore!
- Flashes your screen when your drum cooldown is ready again.
- Can integrate a player that doesn't have the addon in the rotation and whisper him. (However, the next one on the list won't be whispered automatically, when someone who doesn't have the addon finishes his usage. So just keep an eye out if that's the case!)
- Your normal keybindings/actionbars/macros will work with this addon. Simply use your drum any way you want!

## Commands:

### Slash Command:

`/ccd` (stands for "ccDrums") to bring up a configuration GUI, where you can set up things like the audio/whisper notifications, and so on...

_Tip: The most important setting for most people will be to uncheck the "Lock Drums" checkbox to move the drums icon to a better location. Be sure to re-lock it again afterwards so that it won't move by accident!_

### In Party Chat:

`drummers`

Will automatically set up a rotation with everyone else. (On the drum you are currently watching.)

`drummers rotation`

Will advertise the current rotation in the party chat for everyone to see.

`drummers <DrumType> <Name1> [<Name2>...]`

Changes the party's drum rotation to a specific order.

_DrumType is one of: battle, resto, war._

Example: `drummers battle Bob Richard Sonya Thomas`, which will set up a Drums of Battle rotation in that order, assuming all names are in the party.

`drummers <DrumType> <Pos1> <Pos2> <Pos3> <Pos4>`

Changes the order of the current rotation.

Example: `drummers battle 2 1 3 4`, which will switch the 1st and 2nd players in the current rotation so that the 2nd person goes first instead. If assuming the "Bob Richard Sonya Thomas" example above was used, the new rotation would become "Richard Bob Sonya Thomas".

`drummers <DrumType> [Mix of <Name> and <Pos> entries]`

Changes the order _and adds_ someone new in a specific place.

Example: `drummers battle 2 1 3 Philip 4`, which will switch the 1st and 2nd players, and add Philip before the final (4th) player. If assuming the "Bob Richard Sonya Thomas" example above was used, the new rotation would become "Richard Bob Sonya Philip Thomas".

