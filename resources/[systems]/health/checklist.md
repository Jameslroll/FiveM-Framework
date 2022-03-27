### Types of damage
- GSWS (red)
	- Caliber
	- Through and throughs
		- More likely to occur in limbs
- Blunt Damage (brown)
	- Bruising
	- Broken bones
- Stabs (red)
	- Size?
- Burns (orange)
	- External damage
- Bleeding
- Malnourishment
- Dehydration

### Hud
- ~~Flash open upon taking damage or being healed.~~

### Treatments
- Bleeding
	- Requires saline
		- Chance of infection + 1
	- Requires quick clot
		- Chance of rebleeding
	- IF (GSW or )
		- Requires gauze if deep wounds
			- Chance of rebleeding
	- Requires bandages
		- Chance of rebleeding
- Bruising
- Broken bones
	- Strain inflicts more damage
	- Splints to heal over time and restrict further damage from strain

### Extra
- ~~Damage nearby limbs~~
- Internal bleeding
- Stitching
- 

### Items
- C-Collar
- Stretcher
- 

### Death
- That's roleplay

### Release Notes
- Camera movement while down.
- Downed animations instead of ragdoll.
- Supressing native health system.
- Replaced health, armor, food, and water bars with a full body representation.
	- Shows automatically when taking damage, or feeling hungry or thirsy.
	- Can be forced to show with /status.
- Checking injuries replaced with an advanced contextual menu.
	- Commands are still /ci for others and /mi for yourself.
	- EMS need to use /ci to heal your injuries.
- Body armor only stops torso damage.
- Damage per body-part.
- Body-part parameters:
	- Fatal contribution; all body-parts are totalled and at 1.0 you're considered dead. The head maxes out at 1.0 while the hand maxes out at 0.05.
	- Spread to other body-parts; damage like bruising will damage nearby body-parts.
	- Bleed rate; the torso bleeds less than the hand. Amplified by movement.
	- Tremor amount; shaking.
	- Limp amount; hurting your legs too much will give you a limp and make you walk slower.
	- Trip probability; ragdolling randomly, but requires extreme damage to the legs.
	- Faint probability; passing out due to head trauma or extreme blood loss.
- Types of injuries:
	- Bruising.
	- Bleeding.
	- Hemoraging.
	- Fractures.
	- Cranial swelling.
	- Dehydration.
	- Malnourishment.

### Injury Flags
- U = Untreated
- C = Cleaned
- A = Antihemorrhagic
- G = Gauzed
- B = Bandaged
- N = Numbed
- S = Stitched
- I = Icepack