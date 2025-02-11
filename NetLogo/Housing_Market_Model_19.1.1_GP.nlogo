extensions [palette profiler]
globals[
  setup?              ; at setup phase or not

  interestPerTick     ; interest rate, after cyclical variation has been applied; depends on interest rate and ticks per year
  interestPerTickBTL  ; interest rate on the buy-to-let market
  interestPerTickFT   ; interest rate for first-time buyers
  interestPerTickRTB  ; interest rate for right-to-buy buyers

  mortgageToRentHouses              ; ratio of mortgage houses to rent houses

  medianPriceOfHousesForSale        ;; median Price Of Houses For Sale
  medianPriceOfHousesForRent        ;; median Price Of Houses For Rent
  medianPriceOfHousesForSocial      ; median Price Of Houses in social market
  medianPriceOfHousesForRightToBuy  ; median Price Of Houses offfered on a right-to-buy scheme
  medianSalePriceHouses             ; median sale-price of all the houses
  medianRentPriceRentHouses         ; median rent-price of all the houses with myType = "rent"
  medianRentPriceSocialHouses       ; median rent-price of all the houses with myType = "social"
  medianSalePriceXYLocality         ; median sale-price of the houses in the locality of patch at patch-x patch-y
  medianRentPriceXYLocality         ; median rent-price of the houses in the locality of patch at patch-x patch-y
  medianSalePriceXYModifyRadius     ; median sale-price of the houses in the modify-price-radius of patch at patch-x patch-y
  medianRentPriceXYModifyRadius     ; median rent-price of the houses in the modify-price-radius of patch at patch-x patch-y

  medianRichReference               ; median sale-price used to calculate the capital of rich immigrants
  maxRichReference                  ; maximum sale-price used to calculate the capital of rich immigrants

  nupShocked
  ndownShocked
  nUpshockedSell          ; number of owners putting their house for sale because their income has risen
  nDownshockedSell        ; number of owners putting their house for sale because their income has dropped
  nUpshockedRent          ; number of owners putting their house for rent because their income has risen
  nDownshockedRent        ; number of owners putting their house for rent because their income has dropped

  nDiscouraged        ;; number of owners who discouraged by homeless and leave the city
  nExit               ;; number of owners who naturally leave the city or cease to exist
  nEntry              ;; number of owners who naturally enter or born into the city
  moves               ;; number of households moving in this step
  nDemolished

  nForceOutSell           ;; number of owners whose repayment is greater than income and force to leave
  nOwnersOffered          ;; number of owners who made an offer on a house (have enough money and have target to buy)
  meanIncomeForceOutSell  ;; cal the mean income of all owners who are forced out due to low income to repay mortgage
  nForceOutRent           ;; number of owners whose repayment is greater than income and force to leave
  meanIncomeForceOutRent  ;; cal the mean income of all owners who are forced out due to low income to repay mortgage
  nForceInSell
  meanIncomeForceInSell


  nEvictedMortgage           ;; number of evicted owners of type mortgage
  nEvictedRent               ;; number of evicted owners of type rent
  nEnterMarketMortgage       ;; number of owners entering the mortgage market
  nEnterMarketRent           ;; number of owners entering the rent market
  nEnterMarketBuyToLet       ;; number of owners entering the buy-to-let market
  nIndependentMortgage       ;; number of owners recently independent entering the rent market
  nIndependentRent           ;; number of owners recently independent entering the mortgage market
  nForceSell                 ;; number of owners forced to put one of their houses on the buy-to-let market
  meanIncomeEvictedMortgage  ;; mean income of evicted owners of type mortgage
  meanIncomeEvictedRent      ;; mean income of evicted owners of type rent

  nEvictedMortgageOneHouse
  nEvictedMortgageMoreHouses

  nHomeless                  ;; number of owners evicted from their houses (does not include owners coming into the system as immigrants)

  nIndependentThisTick       ;; number of children reaching the independent age (18 in the current version of the model)
  nBirthsThisTick            ;; number of children born this tick
  nDeathsThisTick            ;; number of owners dying this tick

  nWealth10k                  ;; number of owners with wealth between 0 and 10k
  nWealth10k-50k              ;; number of owners with wealth between 10k and 50k
  nWealth50k-500k             ;; number of owners with wealth between 50k and 500k
  nWealth500k-1m              ;; number of owners with wealth between 500k and 2m
  nWealth1m-2m                ;; number of owners with wealth between 2m and 5m
  nWealth2m-5m                ;; number of owners with wealth between 2m and 10m
  nWealth5m                   ;; number of owners with wealth higher than 10m

  gini-wealth                ;; gini index of the wealth

  ageOwnershipWealth                  ;; list of age, number of owned houses and wealth of every household in the system

  transactionsFirstTime      ;; all the transactions made by first time buyers (house prices)
  medianPriceFirstTime       ;; median of transactionsFirstTime

  transactionsRightToBuy     ;; all the transactions made by right to buy buyers (house prices)
  medianPriceRightToBuy      ;; median of transactionsRightToBuy

  visualiseModeCurrent       ;; current used visualisation mode used (prices or types)
  richReferencesCalculated?  ;; indicate whether the price references for rich immigrants were calculated during the run or not

  mortgageConstructionLag    ;; The portion of a mortgage-house that was not completely constructed in the previous tick(s) (always less than 1)
  socialConstructionLag      ;; The portion of a social-house that was not completly constructed in the previous tick(s) (always less than 1)

  rentLeaveLag               ;; The accumilated fraction of rent and social households that did not leave the system in the previous tick(s) (always less than 1)
  mortgageLeaveLag           ;; The accumilated fraction of mortgage households that did not leave the system in the previous tick(s) (always less than 1)

  entryLag                   ;; The accumilated fractio of new households who did not enter the system in the previous tick(s) (always less than 1)
]

breed [houses house ]                  ; a house, may be occupied or not, and may be for sale/mortgage or for rent
breed [owners owner ]                  ; a household, may be living in a house, or may be seeking one
breed [administrators administrator]   ; an legal agent responsible for distributing inheritence after an owner dies
breed [public-sectors public-sector]               ; a council owning the houses with my-type = "social"
breed [realtors realtor ]              ; an estate agent
breed [records record ]                ; a record of a sale, kept by realtors

houses-own[
  myType              ; type of house; mortgage or rent; can be others as well
  local-realtors      ; the local realtors of the house
  local-sales         ; the records for the sale transactions of houses in the intersection of the locality of self and realtor
  local-rents         ; the records for the rent transactions of houses in the intersection of the locality of self and realtor
  locality-houses     ; the houses in my own locality (an agentset)
  end-of-life         ; time step when this house will be demolished
  for-sale?           ; whether this house is currently for sale or rent
  for-rent?           ; whether this house is currently for rent in the private rental market
  for-social?         ; whether this house is currently for rent as a social house
  for-rightToBuy?     ; whether this house is currently offered on the right-to-buy scheme or not
  on-market-period    ; time the house has been on the market
  date-for-sale       ; when the house was put on the market for sale
  date-for-rent       ; when the house was put on the market for rent
  date-for-social     ; when the house was put on the social housing market
  date-for-rightToBuy ; when the house was put on the right-to-buy housing market
  my-owner            ; the owner of this house; owner may not be living in the house if it is rented
  sale-price          ; the price of this house (either now, or when last sold); price sold and rented
  rent-price          ; the rent price of this house
  quality             ; index of quality of this house relative to its neighbours
  my-realtor          ; if for sale/rent, which realtor is selling it
  offered-to          ; which owner has already made an offer for this house
  offer-date          ; date of the offer (in ticks)
  rented-to           ; which renter has already made an offer for this house
  rent-date           ; date of the rent offer (in ticks)
  my-occupier         ; the individual that lives here; can be the owner or the renter
  diversity           ; the diversity index of the house (only used for visualisation)
  G                   ; Getis-Ord z-score for the hotspot analysis
]

owners-own[
  my-house                ; the house which this owner owns/rents
  income                  ; current income from work per year (this is the ONLY yearly measure)
  income-rent             ; income from rent per tick
  income-surplus          ; residual income after spending on housing commodities
  surplus-rent            ; residual rent for each house after deducing its repayment
  mortgage                ; value of mortgage - reduces as it is paid off
  mortgage-initial        ; value of initial mortgage (does not decrease every tick)
  mortgage-type           ; type of mortgage acquired (normal or first-time or buy-to-let)
  mortgage-duration       ; the remaining time on the mortgage
  rate                    ; the yearly interest rate of the currently aggreed mortgage
  rate-duration           ; the remaining years on the current rate (at the end updates)
  capital                 ; capital that I have accumulated from selling my house
  capital-parent          ; portion of capital the agent have access to from parent
  wealth                  ; capital + sale-prices of houses - mortgages
  repayment               ; my mortgage repayment amount, at each tick
  my-rent                 ; rent at each tick
  homeless                ; count of the number of periods that this owner has been without a house
  not-well-off-period     ; count of the number of ticks that this owner has been not well off
  not-well-off?           ; whether the household is not-well-off or not
  myType                  ; type of owner, 1 for owned and 0 for rented
  made-offer-on           ; house that this owner wants to buy/rent
  expected-move-date  ; the tick at which the house will be acquired by the household that made the offer
  date-of-acquire         ; when my-house was bought/rented
  my-ownership            ; houses I own
  inherited-ownership     ; houses inherited from parent (thses are always put on the market to get cash)
  inherited-mortgage      ; the portion of the mortgage inherited from the parent
  on-market?              ; currently on the market or not (myType depicts the type of the market I use)
  on-market-type          ; type of market a buyer is on now
  on-waiting-list?        ; currently on a waiting list or not
  time-on-market          ; number of ticks a buyer has been on the market
  on-cooldown?            ; whether the owner is in the cooldown period or not (cooldown occurs after an owner gets discouraged from the BTL market)
  on-cooldown-type        ; type of market from which the owner is on cooldown ("mortgage" or "buy-to-let")
  time-on-cooldown        ; the number of ticks the owner has been on cooldown
  propensity              ; the probability I will invest in housing
  propensity-social       ; the probability I will apply for social housing if I fit the income criteria
  propensity-wait-for-RTB ; the probability I will wait to reach the right-to-buy occupancy years threshold despite being well-off
  time-in-social-house    ; number of ticks the household spent in social house
  first-time?             ; first time buyer?
  age                     ; age of an owner in ticks
  breed-age               ; age(s) at which an owner gives birth to a child
  death-age               ; age at which an owner dies
  children                ; children of an owner agent
  parent                  ; the parent of this owner agent
]

administrators-own[
  my-ownership       ; the house(s) managed by the administrator
  mortgage           ; the remaining mortgage(s) for the house(s) manage by the administrator
  children           ; the children that inherited the house(s) manage by the administrator
]

public-sectors-own [
  myType             ; type of public sector (e.g., council, NHS)
  my-ownership       ; a list of the owned social housing units
  income-rent        ; a list of the income from the rent of the respective house
  waiting-list       ; a list of households applying for a social house
  vacant-houses      ; a list of vacant houses available
]

realtors-own[
  my-houses-rent           ; the houses in my territory for rent
  sales-rent               ; the last few house for rent that I have made
  my-houses-sold           ; the houses in my territory for sale
  sales-sold               ; the last few house sales that I have made
  average-price       ; the average price (sale) of a house in my territory
  average-rent        ; the average rent of a house in my territory
]

records-own[
  the-house           ; the house that was sold or rented
  selling-price       ; the selling price
  renting-price       ; the renting price
  date                ; the date of the transaction (in ticks)
  filed-at-houses     ; houses that filed the record
]

to reset
  ;; common parameters accross different TicksPerYear (19.0.20)
  set mortgage-lag 3
  set rent-lag 1
  set RTB-lag 3
  set social-lag 1
  set MaxLoanToIncome 4.5
  set MaxLoanToIncomeFT 4.5
  set MaxLoanToIncomeRTB 4.5

  ;; common parameters (19.0.14)
  set Affordability 18
  set Affordability-rent 33
  set BuyerSearchLength 10
  set calculate-wealth? true
  set CapitalMortgage 100
  set CapitalRent 52
  set CapitalSocial 10
  set capital-wealth? false
  set clusteringRepeat 5
  set CycleStrength 0
  set Density 70
  set EntryRate 20
  set eviction-threshold-mortgage 2
  set eviction-threshold-rent 1
  set eviction-threshold-social 1
  set ExitRate 8
  set external-landlords? false
  set external-landlords-per-tick 0
  set FirstTimeBuyersSetup 0
  set FirstTimeBuyersStep 50
  set force-target false
  set FullyPaidMortgageOwners 0
  set HouseConstructionRate 1.44
  set HouseMeanLifetime 100
  set income-shock 20
  set IndependenceAge 21
  set Inheritance-tax? false
  set initial-external-landlords 0
  set InitialGeography "Random"
  set initial-max-income-social 32000
  set initialOccupancy 0.95
  set initialPrice 500000
  set initial-social-houses 50
  set InterestRate 3.7
  set InterestRateBTL 3.7
  set InterestRateFirstTime 3.7
  set InterestRateRTB 3.7
  set investors 0.5
  set Locality 3
  set MaxAge 61
  set MaxBreedAge 40
  set MaxChildren 4
  set MaxDeathAge 90
  set MaxDensity 100
  set MaxLoanToValue 90
  set MaxLoanToValueBTL 90
  set MaxLoanToValueFirstTime 90
  set MaxLoanToValueRTB 90
  set max-price-RTB 100
  set MaxRateDurationBTL 1
  set MaxRateDurationM 5
  set MaxRateDurationRTB 5
  set max-rent-social 120
  set MeanAge 46
  set MeanBreedAge 33
  set MeanChildren 2
  set MeanDeathAge 82
  set MeanIncome 30000
  set MinAge 21
  set MinBreedAge 22
  set MinChildren 0
  set MinDeathAge 61
  set min-price-fraction 0.2
  set MinRateDurationBTL 1
  set MinRateDurationM 2
  set MinRateDurationRTB 2
  set modify-price-radius 6
  set monitor-xy? false
  set MortgageDuration 25
  set MortgageDurationBTL 25
  set MortgageDurationFirstTime 40
  set MortgageDurationRTB 25
  set mPrice 1000000
  set nCouncils 1
  set new-owner-type "random"
  set new-social-houses 10
  set nRealtors 5
  set nYears 400
  set Override-Income-Capital false
  set Owned-Rent-Percentage 50
  set ParentToChildCapital 100
  set patch-x -15
  set patch-y -15
  set price-difference 5000
  set PriceDropRate 12
  set propensity-social-threshold 0.5
  set propensity-wait-for-RTB-threshold 0
  set RealtorOptimism 1
  set RealtorTerritory 16
  set rent-difference 500
  set RentDropRate 12
  set RentToRepayment 120
  set rich-immigrants 0
  set rich-reference "All houses"
  set Right-to-buy? true
  set Right-To-Buy-threshold 10
  set run-max-income-social 30000
  set Savings 20
  set SavingsRent 5
  set SavingsSocial 5
  set savings-to-rent-threshold 5
  set savings-to-social-threshold 1.2
  set scenario "base-line"
  set Shocked 20
  set shock-frequency 0
  set simulate-aging? true
  set social-to-private-rent 50
  set StampDuty? true
  set StampDuty-A? true
  set StampDuty-B? true
  set StampDuty-C? true
  set StampDuty-D? true
  set StampDuty-Rates "Up to 31 March 2025"
  set TargetOwnedPercent 50
  set upgrade-tenancy 0
  set VisualiseMode "Types"
  set WageRise 0

  ;; 19.0.20 baseline
  if baseline-type = "Weekly step" [
    set cooldownPeriodBTL 24
    set cooldownPeriodMortgage 24
    set MaxForRentPeriodPoorLandlord 52
    set MaxHomelessPeriod 52
    set onMarketPeriodBTL 16
    set onMarketPeriodMortgage 16
    set RealtorMemory 120
    set TicksPerYear 52
  ]

  if baseline-type = "1-month step" [
    set cooldownPeriodBTL 12
    set cooldownPeriodMortgage 12
    set MaxForRentPeriodPoorLandlord 12
    set MaxHomelessPeriod 16
    set onMarketPeriodBTL 8
    set onMarketPeriodMortgage 8
    set RealtorMemory 30
    set TicksPerYear 12
  ]

  if baseline-type = "3-month step" [
    set cooldownPeriodBTL 4
    set cooldownPeriodMortgage 4
    set MaxForRentPeriodPoorLandlord 4
    set MaxHomelessPeriod 5
    set onMarketPeriodBTL 1
    set onMarketPeriodMortgage 1
    set RealtorMemory 10
    set TicksPerYear 4
  ]
end

to setup
  clear-all
  reset-ticks
  reset-globals
  ; identify the current state of the model is initialisation
  set setup? true
  set richReferencesCalculated? false
  set transactionsFirstTime (list)

  ; yearly interest rate is converted to interest per tick to be used to calculate finances of the owners at the setup
  set interestPerTick InterestRate / ( TicksPerYear * 100 )
  set interestPerTickBTL InterestRateBTL / ( TicksPerYear * 100 )
  set interestPerTickFT InterestRateFirstTime / ( TicksPerYear * 100 )
  ;no-display ; if do not want to visualize

  ; create public sector agents
  build-public-sectors
  ; create realtors
  build-realtors

  ; create houses
  let total count patches * Density / 100 ; houses density
  ; how many of the total for ownership and how many for rent
  let owned ceiling Owned-Rent-Percentage * total / 100
  let social (total - owned) * (initial-social-houses / 100)
  let rented total - owned - social
  repeat (owned) [ build-house "mortgage"] ; create ownership houses
  repeat (rented) [ build-house "rent"] ; create rent houses
  repeat (social) [ build-house "social"] ; create social houses

  ; create owners
  build-owners
  ask owners [update-surplus-income]

  ; empty houses are for sale/rent; setting sale price (not related to owner)
  reset-empty-houses
  if InitialGeography = "Clustered" [ cluster ]   ;; move houses to the neighbors with similar prices

  reset-houses-quality ; assign quality to houses based on prices in the neighborhood
  reset-realtors ;; initialize sales, my-houses, average-price
  build-records

  ask owners with [my-house != "external"] [update-wealth] ;; updates the wealth of all the households in the system at initialisation

  set VisualiseModeCurrent VisualiseMode
  update-visualisation

  ; identify the current state of the model is running
  set setup? false
end

to build-public-sectors
  create-public-sectors nCouncils [
    set myType "council"
    set my-ownership (list)
    set income-rent (list)
    set waiting-list (list)
    set vacant-houses (list)
  ]
end

to build-realtors
  set-default-shape realtors "flag"  ;;
  let direction random 360
  create-realtors nRealtors [  ;; create one at a time, totally nRealtors
    set color red
    ; distribute realtors in a rough circle
    set heading direction
    jump (max-pxcor - min-pxcor) / 4  ;; jump outward by 1/4 of length of the world
    set direction direction + 120 + random 30 ; prepare direction of jump for the next realtor
    set size 1  ;; original 3, here only 1 is visually good
    ; draw a circle to indicate a realtor's territory
    draw-circle RealtorTerritory   ;; RealtorTerritory is slider global variable
  ]
end

to draw-circle [radius]
;; draw the circumference of a circle at the given radius
  hatch 1 [  ;; based on current turtle, let's create/hatch a new turtle which inherit its parent's properties
    set pen-size 1 set color white set heading -90 fd radius  ;; set up pen size, color and radius for drawing a circle
    set heading 0  ;; set the heading to be tanget line direction
    pen-down
    while [heading < 359 ] [ rt 1 fd (radius * sin 1)  ]  ;; drawing a circle, see the debug proof below
    die  ;; end the drawing turtle
   ]
end

; Called at initialisation to build mortgage and rent houses
; Called during runs to build mortgage houses only
to build-house [mtype]
  set-default-shape houses "house"
  create-houses 1 [
    ; assign type
    set myType mtype
    if myType = "mortgage" [set color yellow]
    if myType = "rent" [set color sky]
    if myType = "social" [set color green]
   ; for speed, dump the house anywhere, check if there is already a house there, and if so, move to an empty spot
    move-to one-of patches
    if count houses-here > 1 [  ;; if more than 1 houses on the current patch ;;  houses-here == turtles-here
      let empty-sites patches with [ not any? houses-here ]  ;; ask every patch to see whether it already has a house on it or not, if not consider it an empty-site
      if any? empty-sites [ move-to one-of empty-sites ]  ;; if empty-sites exist, let current house move to any one of the empty-site
    ]

    ifelse calculate-wealth? = true [
      ; find a list of the local-realtors (list type is required for wealth calculation)
      set local-realtors [self] of realtors with [ distance myself < RealtorTerritory ]
      let temp-locals-list (list)
      repeat length local-realtors [set temp-locals-list lput (list) temp-locals-list]
      set local-sales temp-locals-list
      set local-rents temp-locals-list
      set locality-houses [self] of houses with [distance myself <= locality]
      ask turtle-set locality-houses [set locality-houses lput  myself locality-houses]
      ; if no realtor assigned, then choose nearest
      if not any? turtle-set local-realtors [
        set local-realtors (list min-one-of realtors [ distance myself ])
        set local-sales (list (list))
        set local-rents (list (list))
      ]
    ]
    ; if calculate-wealth? = false
    [
      ; assign to a realtor or realtors if in their territory
      set local-realtors realtors with [ distance myself < RealtorTerritory ]  ;; if the realtor to the house distance < radius, make the realtor(s) for the house
      if not any? local-realtors [ set local-realtors turtle-set min-one-of realtors [ distance myself ] ]  ;; turtle-set to check
    ]
    ;; assign the social house to a public-sector owner
    ifelse myType = "social" [
      set my-owner one-of public-sectors
      ;; we do not add the house to the vacant-houses list of its owner here. Applied later in put-on-market
    ]
    ;; otherwise, the house is build with no owners (owners are later assigned at initialisation to households)
    [set my-owner nobody]
    ;; manage the household parameters
    set my-occupier nobody
    set rented-to nobody
    set offered-to nobody
    ;; Vacant houses with no owners can be placed on the market, and later their owners are assigned
    ;; This must be called after asigning owners as "social" houses access their owner's vacant-houses list
    put-on-market
    ; note how long this house will last before it falls down and is demolished
    set end-of-life ticks + int random-exponential ( HouseMeanLifetime * TicksPerYear )
  ]
end


;; Considers the presence of a rent market
to put-on-market
  ;; reset market period counter
  set on-market-period 0
  ;; add the house to the market
  if myType = "mortgage" [put-on-sale-market]
  if myType = "rent" [put-on-rent-market]
  if myType = "social" and not is-owner? my-occupier [put-on-social-market]
  if myType = "social" and is-owner? my-occupier [put-on-rightToBuy-market]
end

;; adds the house to the sale market
to put-on-sale-market
  set for-sale? true
  set for-rent? false
  set for-social? false
  set for-rightToBuy? false
  set offered-to nobody
  set date-for-sale ticks
end

;; adds the house to the private rental market
to put-on-rent-market
  set for-sale? false
  set for-rent? true
  set for-social? false
  set for-rightToBuy? false
  set offered-to nobody
  set date-for-rent ticks
end

;; adds the house to the social housing market
to put-on-social-market
  set for-sale? false
  set for-rent? false
  set for-social? true
  set for-rightToBuy? false
  set offered-to nobody
  set date-for-social ticks
  ask my-owner [set vacant-houses lput myself vacant-houses]
end

;; makes the house available for the right-to-bu scheme
to put-on-rightToBuy-market
  set for-sale? false
  set for-rent? false
  set for-social? false
  set for-rightToBuy? true
  set date-for-rightToBuy ticks
end

;; create owners
to build-owners
  set-default-shape owners "dot"  ;; all owners are dots
  ; Calculate the number of households at initialisation
  let n-total floor (initialOccupancy * count houses) ; total occupancy
  let n-mortgage floor (Owned-Rent-Percentage / 100 * n-total) ; owned occupancy
  let n-social floor (n-total - n-mortgage) * (initial-social-houses / 100)
  let n-rent n-total - n-mortgage - n-social                       ; rented occupancy
  ;; available indicates houses without occupiers
  let available-owned nobody
  let available-rented nobody
  let available-social nobody
  let count-notavailable-owned 0
  let count-notavailable-rented 0
  let count-notavailable-social 0

  ; setting availabilities by comparing the target households (variables with n) and the actual vacant houses in the system
  if (n-mortgage > count houses with [myType = "mortgage"]) [
    set available-owned houses with [myType = "mortgage"]
    set count-notavailable-owned n-mortgage - count houses with [myType = "mortgage"]
  ]
  if (n-mortgage <= count houses with [myType = "mortgage"]) [
    set available-owned n-of n-mortgage houses with [myType = "mortgage"]
  ]
  if (n-rent > count houses with [myType = "rent"]) [
    set available-rented houses with [myType = "rent"]
    set count-notavailable-rented n-rent - count houses with [myType = "rent"]
  ]
  if (n-rent <= count houses with [myType = "rent"]) [
    set available-rented n-of n-rent houses with [myType = "rent"]
  ]
  if (n-social > count houses with [myType = "social"]) [
    set available-social houses with [myType = "social"]
    set count-notavailable-rented n-social - count houses with [myType = "social"]
  ]
  if (n-social <= count houses with [myType = "social"]) [
    set available-social n-of n-social houses with [myType = "social"]
  ]

  ask available-owned [  ;; define each home-owner's properties
    ;; since owners living inside, it should not for-sale or for rent now
    set for-sale? false
    set for-rent? false
    set for-social? false
    hatch-owners 1 [  ;; create an owner inside this house
      ; define whether the owner bought its current my-house as a first-time buyer or not
      let FT false
      if random 100 < FirstTimeBuyersSetup [set FT true]
      ; address owner agent parameters
      set color black  ;; make owner red
      set size 0.7   ;; owner easy to see but not too big
      set propensity random-float 1.0
      set propensity-social random-float 1.0
      set propensity-wait-for-RTB random-float 1.0
      ; not a first-time buyer in the next purchase
      set first-time? false
      set my-house myself  ;; owner claims its house
      ;; added occupier and rented-to
      set my-ownership (list myself)
      ask my-house [set my-owner myself set my-occupier myself set rented-to nobody] ;; ask the house to claim its owner and occupier

      set mytype "mortgage" ; owner
      assign-income ;; create income and capital for owner#
      ;; address rent from house (owner lives in the house, and accordingly income-rent = 0
      set income-rent (list 0)
      set surplus-rent (list 0)
      ;; address mortgage rate duration (can be assigned regardless of actual mortgage)
      set rate-duration (list ( (MinRateDurationM + random (MaxRateDurationM - MinRateDurationM)) * ticksPerYear) )
      ifelse FT = true
      ; first-time buyer
      [
        set mortgage-type (list "first-time")
        set rate (list interestPerTickFT)
        set mortgage-duration (list (MortgageDurationFirstTime * ticksPerYear))
      ]
      ; not first-time buyer
      [
        set mortgage-type (list "normal")
        set rate (list interestPerTick)
        set mortgage-duration (list (MortgageDuration * ticksPerYear))
      ]

      let deposit 0

      ; maximum repayment
      ; "repayment--> mortgage--> price"
      let max-repayment (income * Affordability / (ticksPerYear * 100))
      let MaxLoanToValue-temp 0
      let MaxLoanToIncome-temp 0
      let interestPerTick-temp 0
      ; assign a random percent as first time buyers for their current my-house
      ifelse FT = true
      [
        set MaxLoanToValue-temp MaxLoanToValueFirstTime
        set MaxLoanToIncome-temp MaxLoanToIncomeFT
        set interestPerTick-temp interestPerTickFT
      ]
      ;; if first time buyers are not simulated, ignore the FristTime variables
      [
        set MaxLoanToValue-temp MaxLoanToValue
        set MaxLoanToIncome-temp MaxLoanToIncome
        set interestPerTick-temp interestPerTick
      ]
      ;; calculate the maximum mortgage the household can acquire based on:
      ;; (1) income
      ;; (2) capital
      ;; (3) loan-to-income
      ;; and select the minimum of these values
      let max-mortgage min ( list (
        (1 - ( 1 + interestPerTick-temp ) ^ ( - (item 0 mortgage-duration) * TicksPerYear )) * max-repayment / interestPerTick-temp )
        ( (capital * (MaxLoanToValue-temp / 100)) / (1 - (MaxLoanToValue-temp / 100)) )
        ( income * MaxLoanToIncome-temp )
      )
      ;; manage mortgage and deposit parameters
      set mortgage (list max-mortgage)
      set mortgage-initial (list item 0 mortgage)
      set repayment (list( item 0 mortgage * interestPerTick-temp / (1 - ( 1 + interestPerTick-temp ) ^ ( - (item 0 mortgage-duration) * TicksPerYear )) ))
      set deposit ( item 0 mortgage * ( 100 /  MaxLoanToValue-temp - 1 ) )  ;; create deposit


      ;; create sale-price = mortgage + deposit for the house
      ask my-house [
        set sale-price [item 0 mortgage] of myself + deposit
        set rent-price 0
      ]
      ;; manage age
      assign-age self
      ;; manage on-market parameters
      set on-market? false
      set on-market-type (list)
      set on-waiting-list? false
    ]
  ]

  ;; assign tenants and landlords to the houses rented
  ask available-rented [
    ;; since owners living inside, it should not be for-sale or for rent
    set for-sale? false
    set for-rent? false
    hatch-owners 1 [  ;; create an owner (tenant) inside this house
      set color white  ;; make owner red
      set size 0.7   ;; owner easy to see but not too big
      set propensity random-float 1.0
      set propensity-social random-float 1.0
      set propensity-wait-for-RTB random-float 1.0
      ifelse random 100 < FirstTimeBuyersSetup
      [set first-time? True]
      [set first-time? False]
      set my-house myself  ;; owner claims its house
      ;; manage ownership of house and owner agent
      set my-ownership (list)
      let owner-temp nobody
      ; if the owner is not an external landlord (i.e., living outside the system)
      ifelse external-landlords? = false or ( external-landlords? = true and random 100 > initial-external-landlords)
      [ set owner-temp one-of owners with [mytype = "mortgage"] ]
      ; if the owner is an external landlord
      [
        ask one-of owners with [myType = "mortgage"] [
          hatch 1 [
            set my-house "external"
            let my-ownership-temp (list)
            foreach my-ownership [h -> set my-ownership-temp lput "external" my-ownership-temp]
            set my-ownership my-ownership-temp
            set breed-age (list)
            set children (list)
            set parent nobody
            set owner-temp self
          ]
        ]
      ]
      let house-temp myself
      set mytype "rent" ; renter/tenant (i.e., someone living now in a rented house)
      assign-income ;; create income and capital for owner (i.e. renter)
      ;; renters do not pay mortgage and have no repayments, but they pay rent
      let rent income * Affordability-rent / (ticksPerYear * 100 ) ;; create rent
      ;; Manage mortgage parameters
      ;; address mortgage rate duration (can be assigned regardless of actual mortgage)
      set rate (list)
      set rate-duration (list)
      set mortgage-duration (list)
      set mortgage-type (list)
      let price 0
      let mortgage-budget 0
      let mortgage-income 0
      let mortgage-temp 0
      let deposit-temp 0
      let repayment-temp 0

      ;; calculate repayment, mortgage and deposit
      ;; accordingly set price of house
      ; repayment--> mortgage--> price
      set repayment-temp [income] of owner-temp * Affordability / (ticksPerYear * 100 )
      set mortgage-budget (1 - ( 1 + interestPerTickBTL ) ^ ( - MortgageDurationBTL * TicksPerYear )) * repayment-temp / interestPerTickBTL
      set mortgage-income MaxLoanToIncomeFT * [income] of owner-temp
      set mortgage-temp min (list mortgage-budget mortgage-income )
      set deposit-temp mortgage-temp * ( 100 /  MaxLoanToValueBTL - 1 )
      set price mortgage-temp + deposit-temp


      ;; safegaurd that landlords at least recover their repayments from the rent (this leads to much higher rents with higher interest rates)
      if rent < repayment-temp * (RentToRepayment / 100) [
        set rent repayment-temp * (RentToRepayment / 100)
        ;; safegaurd that tenants will be able to pay the rent
        set income (rent * ticksPerYear) / (Affordability-rent / 100)
      ]
      ;; add an owner to the rented house (required for adding the rent value to that person) and manage the house's parameters
      ask my-house [
        set my-owner owner-temp
        set my-occupier myself
        set rented-to myself
        set sale-price price
        set rent-price rent
      ]
      ;; manage ownership, mortgage, repayment and rent of the landlord of the house
      ask owner-temp [
        set my-ownership lput (house-temp) (my-ownership)
        set mortgage lput (price) (mortgage)
        set mortgage-initial lput (price) (mortgage-initial)
        set mortgage-type lput ("buy-to-let") (mortgage-type)
        set repayment lput (repayment-temp) (repayment)
        set income-rent lput rent income-rent
        set surplus-rent lput (rent - repayment-temp) surplus-rent
        set rate lput (interestPerTickBTL) (rate)
        set rate-duration lput ((MinRateDurationBTL + random (MaxRateDurationBTL - MinRateDurationBTL)) * ticksPerYear) (rate-duration)
        set mortgage-duration lput (MortgageDurationBTL * ticksPerYear) mortgage-duration
      ]
      set my-rent rent
      ;; intialise mrotgage, repayment and income-rent as empty lists
      set mortgage (list)
      set mortgage-initial (list)
      set mortgage-type (list)
      set repayment (list)
      set income-rent (list)
      set surplus-rent (list)
      set on-market? false
      set on-market-type (list)
      set on-waiting-list? false
      ask my-house [ set sale-price price set rent-price rent ] ;; create rent-price = rent
      ;; Safegaurd that the owner does not get evicted due to very minor differences (fractions) between the rent and the income
      set income income * 1.01
      assign-age self
    ]
  ]

  ;; assign owners (i.e., landlords) to houses available on the rent market (i.e., not occupied)
  ask houses with [myType = "rent" and for-rent? = true] [
    let owner-temp one-of owners with [mytype = "mortgage"]
    let house-temp self
    ;; manage the parameters of the selected owner
    ask owner-temp [
      set my-ownership lput (house-temp) (my-ownership)
      ;; repeat the mortgage (we assume sale-prices are based on income, this makes the sale-price of all houses owned by one owner the same at initialisation)
      set mortgage lput (item 0 mortgage) (mortgage)
      set mortgage-initial lput (item 0 mortgage-initial) (mortgage-initial)
      set mortgage-type lput ("buy-to-let") mortgage-type
      set repayment lput (item 0 repayment) (repayment)
      set income-rent lput 0 (income-rent)
      set surplus-rent lput (0 - item 0 repayment) surplus-rent
      ;; address mortgage rate duration (can be assigned regardless of actual mortgage)
      set rate lput (interestPerTickBTL) (rate)
      set rate-duration lput ((MinRateDurationBTL + random (MaxRateDurationBTL - MinRateDurationBTL)) * ticksPerYear) (rate-duration)
      set mortgage-duration lput (MortgageDurationBTL * ticksPerYear) mortgage-duration
    ]
    ;; manage the parameters of the house
    ask house-temp [
      set my-owner owner-temp
      set my-occupier nobody
      set rented-to nobody
      ;; set sale price of the rented house the same as the sale-price of my-house of the main owner but make sure the deposit reflects the BTL LTV (this is an assumption at set-up)
      let deposit-temp (item 0 [mortgage] of my-owner) * ( 100 /  MaxLoanToValueBTL - 1 )
      set sale-price (item 0 [mortgage] of my-owner) + deposit-temp
      set rent-price median [rent-price] of houses with [myType = "rent" and for-rent? = false]
    ]
  ]


  ;; assign tenants and landlords to the houses rented
  ask available-social [
    ;; since owners living inside, it should not be for-sale or for rent
    set for-sale? false
    set for-rent? false
    set for-social? false
    hatch-owners 1 [  ;; create an owner (tenant) inside this house
      set color yellow  ;; make owner red
      set size 0.7   ;; owner easy to see but not too big
      set propensity random-float 1.0
      set propensity-social random-float 1.0
      set propensity-wait-for-RTB 1.0
      set my-house myself  ;; owner claims its house
      set time-in-social-house random right-to-buy-threshold * ticksPerYear
      ;; manage ownership of house and owner agent
      set my-ownership (list)
      let owner-temp one-of public-sectors
      let house-temp myself
      ask house-temp [set my-owner owner-temp]
      ask owner-temp [set vacant-houses remove house-temp vacant-houses]
      set myType "social" ; social housing tenant (i.e., someone living now in a rented social house)
      assign-income ;; create income and capital for owner (i.e. renter)

      ;; generate a random income to set the rent and price of the house
      let income-temp generate-random-income
      ;; assure households can afford the rent, if not, decrease the rent
      ;; This is allowed as, unlike landlords, public sectors are not restricted to mortgages in this model
      ;; so, they have no incentive to increase rent
      let rent (income-temp * Affordability-rent / (ticksPerYear * 100 )) * (social-to-private-rent / 100)
      if rent > (income * Affordability-rent / (ticksPerYear * 100 )) [set rent (income * Affordability-rent / (ticksPerYear * 100 ))]

      ;; calculate the price of the house based on the income-temp
      let price 0
      let mortgage-temp 0
      let deposit-temp 0
      let repayment-temp 0
      ; repayment--> mortgage--> price
      set repayment-temp income * Affordability-rent / (ticksPerYear * 100 )
      set mortgage-temp (1 - ( 1 + interestPerTickBTL ) ^ ( - MortgageDurationBTL * TicksPerYear )) * repayment-temp / interestPerTickBTL
      set deposit-temp mortgage-temp * ( 100 /  MaxLoanToValueBTL - 1 )
      set price mortgage-temp + deposit-temp

      ;; manage ownership of council
      ask owner-temp [
        set my-ownership lput (house-temp) (my-ownership)
        set income-rent lput rent income-rent
      ]
      set my-rent rent
      ;; intialise mrotgage, repayment and income-rent as empty lists
      set rate (list)
      set rate-duration (list)
      set mortgage (list)
      set mortgage-initial (list)
      set mortgage-type (list)
      set mortgage-duration (list)
      set repayment (list)
      set income-rent (list)
      set surplus-rent (list)
      set on-market? false
      set on-market-type (list)
      set on-waiting-list? false
      ;; manage the parameters of the house
      ask my-house [
        set my-occupier myself
        set rented-to myself
        ;; create rent-price = rent
        set sale-price price
        set rent-price rent
      ]
      ;; assign an age to the household
      assign-age self
    ]
  ]

  ;; assure social houses with no occupier are added to the vacant list
  ask houses with [myType = "social" and not is-owner? my-occupier] [
    ask one-of public-sectors [set vacant-houses lput myself vacant-houses]
  ]

  ; households not assigned a house
  if count-notavailable-owned > 0 [
    ;; Create a household that joins a market
    create-owners count-notavailable-owned [
      set color black  ;; make owner red
      set size 0.7   ;; owner easy to see but not too big
      set propensity random-float 1.0
      set propensity-social random-float 1.0
      set propensity-wait-for-RTB random-float 1.0
      ifelse random 100 < FirstTimeBuyersSetup
      [set first-time? True]
      [set first-time? False]
      set first-time? True
      set my-house nobody
      set my-ownership (list)
      set mytype "mortgage" ; mortgage owner
      assign-income ;; create income and capital for owner
      ;let rent income * Affordability / (ticksPerYear * 100 ) ;; create rent
      set my-rent 0
      set mortgage (list)
      set mortgage-initial (list)
      set mortgage-type (list)
      set repayment (list)
      set income-rent (list)
      set surplus-rent (list)
      set rate (list)
      set rate-duration (list)
      set mortgage-duration (list)
      ;; assign the household to a market based on its type
      enter-market self myType
      ;; assign age to the household
      assign-age self
    ]
  ]

  ; tenants without houses at initialisation assigned
  if count-notavailable-rented > 0 [
    create-owners count-notavailable-rented [  ;; create an owner inside this house
      set color white  ;; make owner red
      set size 0.7   ;; owner easy to see but not too big
      set propensity random-float 1.0
      set propensity-social random-float 1.0
      set propensity-wait-for-RTB random-float 1.0
      ifelse random 100 < FirstTimeBuyersSetup
      [set first-time? True]
      [set first-time? False]
      set my-house nobody
      set my-ownership (list)
      set mytype "rent" ; renter

      assign-income ;; create income and capital for owner
      set my-rent 0
      set mortgage (list)
      set mortgage-initial (list)
      set mortgage-type (list)
      set repayment (list)
      set income-rent (list)
      set surplus-rent (list)
      set rate (list)
      set rate-duration (list)
      set mortgage-duration (list)
      ;; Assign the household to the market given its type (rent)
      enter-market self myType
      ;; Assign the household an age
      assign-age self
    ]
  ]

  ;; pay the mortgage of a portion of the owners (this cannot be applied when calculating the mortgages as the mortgage values are necessary to set prices)
  if FullyPaidMortgageOwners > 0 [

    ask owners with [myType = "mortgage"] [
      if FullyPaidMortgageOwners >= random 100 [
        let i 0
        let l length my-ownership
        ;; loop through all the ownership houses and pay the mortgage
        while [i < l] [
          set mortgage replace-item i mortgage 0
          set mortgage-initial replace-item i mortgage-initial 0
          set mortgage-duration replace-item i mortgage-duration nobody
          set repayment replace-item i repayment 0
          set surplus-rent replace-item i surplus-rent (item i income-rent)
          set rate replace-item i rate 0
          set rate-duration replace-item i rate-duration nobody
          set i i + 1
        ]
      ]
    ]
  ]
end

;; used at initialisation and with immigrants
to assign-age [input-owner]
  ask input-owner [
    set age -1
    set breed-age (list)
    set death-age -1
    set children (list)
    ;; generate age
    while [age < MinAge or age > MaxAge] [set age (random-normal MeanAge 20)]
    set age floor (age * TicksPerYear)
    ;; define death age and breed age
    assign-breed-death-age self
    ;; add placeholders for children already given birth to
    let i 0
    while [i < length breed-age] [
      if age >= item i breed-age [set children lput nobody children]
      set i i + 1
    ]
  ]
end

;; used when giving birth to a new agent (as its age is predefined in the manage-age function)
to assign-breed-death-age [input-owner]
  ask input-owner [
    ;; define death age
    while [death-age < MinDeathAge or death-age > MaxDeathAge] [set death-age (random-normal MeanDeathAge 20)]
    set death-age floor (death-age * TicksPerYear)
    ;; define number of children
    let n -1
    while [n < MinChildren or n > MaxChildren][set n random-normal MeanChildren 2]
    ;; dictate breeding ages
    let age-temp -1
    repeat int(n) [
      while [age-temp < MinBreedAge or age-temp > MaxBreedAge][set age-temp random-normal MeanBreedAge 10]
      set breed-age lput floor (age-temp * TicksPerYear) (breed-age)
      set age-temp -1
    ]
    set breed-age sort breed-age
  ]
end

to assign-income

;; an owner's income is a random number from a particular gamma distribution
;; an owner's capital is a proportion of income

;; income distribution formula is based on the following paper
;; parameters taken from http://www2.physics.umd.edu/~yakovenk/papers/PhysicaA-370-54-2006.pdf

  let MeanIncome-temp MeanIncome
  ;; override mean income if it does not cover the mean repayments
  let mean-deposit 0
  let min-deposit 0
  ;; if we want to force the model to override the mean income if it does not cover the repayment
  ;; this ignores the income from rent. It was added to test whether this will cahge the income distributions of landlords or not
  ;; advised not to use in baseline experiments as they can be disruptive at wider distributions of prices in a household's my-ownership
  if (Override-Income-Capital = true and setup? = false) [
    let mean-price 0
    let min-price 0
    if any? houses with [myType = "mortgage" and sale-price > 0 and for-sale? = true] [
      set mean-price max list (mean [sale-price] of houses with [myType = "mortgage" and sale-price > 0 and for-sale? = true]) (medianPriceOfHousesForSale)
      set min-price max list (min [sale-price] of houses with [myType = "mortgage" and sale-price > 0 and for-sale? = true]) (min [sale-price] of houses with [myType = "mortgage" and sale-price > 0])
    ]
    set mean-deposit mean-price * ( 1 - (MaxLoanToValue / 100) )
    set min-deposit min-price * ( 1 - (MaxLoanToValue / 100) )
    let mean-mortgage mean-price * (MaxLoanToValue / 100)
    let mean-repayment mean-mortgage * interestPerTick / ( 1 - (1 + interestPerTick) ^ (- MortgageDuration * TicksPerYear) )
    set MeanIncome-temp max list (mean-repayment * TicksPerYear) (MeanIncome)
  ]


  ;; define the gamma distribution parameters for income
  let alpha 1.3
  let lambda 1 / 20000
  set income 0

  ; avoid impossibly low incomes (i.e. less than half the desired mean income)
  while [ income < MeanIncome-temp / 2 ] [  ;; as long as income is less than half of median income
    set income (MeanIncome-temp * lambda / alpha ) * (random-gamma alpha lambda) *
    (1 + (WageRise / (TicksPerYear * 100)) ) ^ ticks  ;; redefine income value with this equation (check the paper for details )
  ]
  ;; assign the income-surplus initially as the income per tick (deductions will be made later from the income surplus)
  set income-surplus income / ticksPerYear

  ; if override capital is on, assure the mortgage owners have enough capital to at least buy the cheapest house on the market
  ifelse (Override-Income-Capital = true and setup? = false) [
    if myType = "mortgage" [set capital max list (income * CapitalMortgage / 100) ( (min-deposit + mean-deposit) / 2)]
  ]
  ; if not, give them a proportion of a year's income as their savings
  [
    if myType = "mortgage" [set capital income * CapitalMortgage / 100]
  ]
  if myType = "rent" [set capital income * CapitalRent / 100]
  if myType = "social" [set capital income * CapitalSocial / 100]
  ;; assign the wealth as the capital
  ifelse capital-wealth? = true [set wealth capital] [set wealth 0]

end

to-report generate-random-income
  ;; Define the gamma distribution parameters
  let alpha 1.3
  let lambda 1 / 20000
  let output-income 0
  let MeanIncome-temp meanIncome
  ; avoid impossibly low incomes (i.e. less than half the desired mean income)
  while [ output-income < MeanIncome-temp / 2 ] [  ;; as long as income is less than half of median income
    set output-income (MeanIncome-temp * lambda / alpha ) * (random-gamma alpha lambda) *
    (1 + (WageRise / (TicksPerYear * 100)) ) ^ ticks  ;; redefine income value with this equation (check the paper for details )
  ]

  report output-income
end

;; assign higher income to a richer population
to assign-income-rich
  ;; calculate the parameters that dictate the rich thresholds
  if richReferencesCalculated? = false [
    (ifelse
      ;; consider all houses
      rich-reference = "All houses" [
        set medianRichReference median [sale-price] of houses
        set maxRichReference max [sale-price] of houses
      ]
      ;; consider houses at location XY within a defined radius
      rich-reference = "XY modify radius houses" [
        ask patch patch-x patch-y [
          set medianRichReference median [sale-price] of houses in-radius modify-price-radius
          set maxRichReference max [sale-price] of houses in-radius modify-price-radius
        ]
      ]
    )
    set richReferencesCalculated? true
  ]

  ;; increase capital and income
  set capital (medianRichReference + random (maxRichReference - medianRichReference)) * ( ((100 - maxLoanToValueFirstTime) / 100) * 2 )
  set income meanIncome + random (max [income] of owners - meanIncome)
  set income-surplus income / ticksPerYear

end

;; assign the income while considering rent
to assign-income-rent
  let total-rent 0
  let total-mortgage 0
  ;; manage rent to loandlord in both cases if the house is occupied or not
  ask turtle-set my-ownership [
    ifelse is-owner? rented-to [
      ask myself [set income-rent lput [rent-price] of myself income-rent]
    ]
    [
      ask myself [set income-rent lput 0 income-rent]
    ]
  ]
  ;; calculate surplus income and capital
  set income-surplus sum(income-rent) + (income / ticksPerYear)
  set capital income * CapitalMortgage / 100
end

;; update the surplus income while considering income from rent and costs of repayments
to update-surplus-income
  set income-surplus (income / ticksPerYear) + sum(income-rent) - sum(repayment) - my-rent
end

;; update then available capital the household has access to from parent
to update-capital-parent
  if is-owner? parent [
    set capital-parent ([capital] of parent * (ParenttoChildCapital / 100)) / (length [children] of parent)
  ]
end

;; update the cooldown time if the household was discouraged from a market
to update-cooldown
  ;; if the household is on BTL cooldown and have not reached the end of its cooldown period
  if on-cooldown? = true and on-cooldown-type = "buy-to-let" [
    if time-on-cooldown < cooldownPeriodBTL [set time-on-cooldown time-on-cooldown + 1]
    ;; if the household reached the end of its cooldown period
    if time-on-cooldown >= cooldownPeriodBTL [
      set on-cooldown? false
      set time-on-cooldown 0
      set on-cooldown-type nobody
    ]
  ]

  ;; if the household is on mortgage market cooldown and have not reached the end of its cooldown period
  if on-cooldown? = true and on-cooldown-type = "mortgage" [
    if time-on-cooldown < cooldownPeriodMortgage [set time-on-cooldown time-on-cooldown + 1]
    ;; if the household reached the end of its cooldown period
    if time-on-cooldown >= cooldownPeriodMortgage [
      set on-cooldown? false
      set time-on-cooldown 0
      set on-cooldown-type nobody
    ]
  ]

end

;; update the period a household has been not-well-off
to update-not-well-off
  if not-well-off? = true [set not-well-off-period not-well-off-period + 1]
end

;; update the wealth of a household
to update-wealth
  ;; ignore external households
  if calculate-wealth? = True and my-house != "external" [
    let i 0
    set wealth 0
    ;; Address all the owned houses
    while [i < length my-ownership] [
      let mortgage-temp item i mortgage
      let my-ownership-temp item i my-ownership
      let myType-temp [myType] of item i my-ownership
      let sale-price-temp 0
      ;; re-evaluate the prices of the houses
      ask my-ownership-temp [
        ;; temporarly set the type of the house to mortgage so that realtors report a sale price (not a rent price)
        set myType "mortgage"
        set my-realtor max-one-of turtle-set local-realtors [ valuation myself ]               ;; set the realtor that gives the current house the highest valuation to be my-realtor
        ask my-realtor [set sale-price-temp valuation my-ownership-temp]
        set myType myType-temp      ;; revert the house to its original type
      ]
      set wealth wealth + (sale-price-temp - mortgage-temp)
      set i i + 1
    ]
  ]
end

to reset-empty-houses
  ;; For vacant houses, without owners, those houses have no sale-prices, my-owner properties

  let median-price 0
  let median-rent 0

  ; initial random assignments
  set median-price median [ sale-price ] of houses with [ sale-price > 0 and myType = "mortgage"] ;; median sale-prices of all houses with owners
  ;; consider rent-price for rented houses
  set median-rent median [ rent-price ] of houses with [ rent-price > 0 and myType = "rent"] ;; median sale-prices of all houses with owners
  ;; check my-occupier for empty houses
  ask houses with [ not (is-owner? my-occupier) and myType = "mortgage" and not is-owner? offered-to] [  ;; loop each empty house owned?
    let local-houses-sale houses with [distance myself < Locality and sale-price > 0 and myType = "mortgage"]
    let local-houses-rent houses with [distance myself < Locality and rent-price > 0 and myType = "rent"]

    ;; assign sale
    ;; find all local houses of the empty house = locality distance and has owner with sale-price
    ifelse any? local-houses-sale ;; if there exist local houses,
        [ set sale-price  median [ sale-price ] of local-houses-sale
    ]  ;; use local houses median price as the empty house sale-price
    [ set sale-price  median-price
    ]  ;; otherwise, use all occupied houses median price for the empty house sale-price

    ;; assign rent
    ;; find all local houses of the empty house
    ifelse any? local-houses-rent
        [ set rent-price  median [ rent-price ] of local-houses-rent ]  ;; use local houses median price as the empty house sale-price
    [ set rent-price  median-rent ]  ;; otherwise, use all occupied houses median price for the empty house sale-price

  ]
  ;; consider rent-price of local houses
  ask houses with [ not (is-owner? my-occupier) and myType = "rent" and not is-owner? offered-to] [  ;; loop each empty house NOT owned?
    let local-houses houses with [distance myself < Locality and rent-price > 0 and myType = "rent"]
    ;; find all local houses of the empty house
    ifelse any? local-houses
      [ set rent-price  median [ rent-price ] of local-houses ]  ;; use local houses median price as the empty house sale-price
    [ set rent-price  median-rent ]  ;; otherwise, use all occupied houses median price for the empty house sale-price
  ]
end

to cluster
  ;; cluster houses together based on price similarity
  let owned-houses houses with [myType = "mortgage"]
  let rented-houses houses with [myType = "rent"]
  cluster-type owned-houses price-difference
  cluster-type rented-houses rent-difference
end

to cluster-type [all-houses diff]
  repeat clusteringRepeat [  ;;  cluster all all houses x times
    let houses-to-move sort-by [ [ house1 house2 ] ->  price-diff house1 > price-diff house2 ] all-houses  ;; new-version
    ;; reorder every house based on price-difference to its neighbor houses, largest first, smallest last
    foreach houses-to-move [  ;; loop each house
      x -> if price-diff x >= diff [  ;; if current house price is way too different from its surroundign houses
        let vacant-plot one-of patches with [  ;; get one of many empty patches, where
                                   not any? houses-here and  ;; there is no house built
                                   abs (local-price - [ sale-price ] of x ) < (diff / 5) ]  ;; where the surrounding house prices is similar to the current house
        if vacant-plot != nobody [  ;; if those empty patches do exist
          ask x [  ;; ask this current house
            move-to vacant-plot  ;; to move to one of the empty patch
            if is-owner? my-occupier [  ;; whether it got an owner, if so
              ask my-occupier [ move-to myself ] ;; ask the owner move to where the house is
            ]
          ]
        ]
      ]
    ]
  ]
end

;; calculate the differeence between the price of the house and its locality
to-report price-diff [ a-house ]
  report abs ([sale-price] of a-house - [local-price] of a-house) ;; Note the use [ local-price ] of a-house
end

to-report local-price
  let local-houses houses-on neighbors  ;; based on the current patch, looking for its eight neighbor patches, put all the houses on those patches under `local-houses`
  ;; report prices of mortgaged houses only (do not report prices of rented houses)
  ifelse any? local-houses with [mytype = "mortgage"]  ;; if `loca-houses` is not empty
    [ report median [sale-price] of local-houses with [mytype = "mortgage"] ]  ;; report median price of all neighbor houses' sale-prices to be `local-price`
    [ report 0 ] ;; if no neighbor houses, report 0 to be `local-price`
end

to reset-houses-quality

  set medianPriceOfHousesForSale median [sale-price] of houses with [myType = "mortgage"]  ;; get median price for all houses owned
  set medianPriceOfHousesForRightToBuy  median [sale-price] of houses with [myType = "social"]  ;; get median price for all houses owned
  set medianPriceOfHousesForRent median [rent-price] of houses with [myType = "rent"]  ;; get median price for all houses not owned

  ask houses with [myType = "mortgage"] [
    set quality sale-price / medianPriceOfHousesForSale  ;; quality is sale-price/median-price
    if quality > 3 [set quality 3] if quality < 0.3 [set quality 0.3]  ;; quality is between 0.3 to 3
    ;set color scale-color color quality 5 0  ;; quality by magenta scale
  ]

  ask houses with [myType = "social"] [
    set quality sale-price / medianPriceOfHousesForSale  ;; quality is sale-price/median-price
    if quality > 3 [set quality 3] if quality < 0.3 [set quality 0.3]  ;; quality is between 0.3 to 3
    ;set color scale-color color quality 5 0  ;; quality by magenta scale
  ]

  ;; address rented houses
  ask houses with [myType = "rent"] [
    set quality rent-price / medianPriceOfHousesForRent  ;; quality is sale-price/median-price
    if quality > 3 [set quality 3] if quality < 0.3 [set quality 0.3]  ;; quality is between 0.3 to 3
    ;set color scale-color color quality 5 0  ;; quality by magenta scale
  ]
end

to reset-realtors

  ask realtors [
    set sales-sold [] ;; take sales as empty list
    set sales-rent [] ;; take sales as empty list

    set my-houses-sold houses with [member? myself turtle-set local-realtors and myType = "mortgage"]
    set my-houses-rent houses with [member? myself turtle-set local-realtors and myType = "rent"]

    set average-price median [ sale-price ] of my-houses-sold
    ;; consider average rent
    set average-rent median [ rent-price ] of my-houses-rent
  ]
end

to build-records
  ;; create records for each and every house
  ;; at the start, every house is assumed to be sold previously and has a record
  ;; the house's sale-price is the record's selling-price,
  ;; my-realtor is set randomly at the start, and this realtor will store the record into its sales list

  set-default-shape records "square"
  ask houses [ ;; loop each house

    let the-record nobody ;; `the-record` is nobody
    hatch-records 1 [  ;; hatch a record from a house
      hide-turtle  ;; hide the current record

      set the-house myself   ;; take the current house to be the-house of the current record
      set selling-price [ sale-price ] of myself  ;; take the sale-price of the house to be selling-price of the current record
      ;; consider renting prices
      set renting-price [ rent-price] of myself
      ;; consider filed records

      set the-record self                           ;; use the-record to carry the current record outside the hatch function into the house context
    ]

    set my-realtor one-of local-realtors  ;; randomly take one of the local-realtors to be my-realtor of the current house

    file-record my-realtor the-record  ;; ask my-realtor to save the current record (the-record) into sales of my-realtor


  ]

end

to file-record [ input-realtor the-record ]         ;; global procedure
  ; push this sales record onto the list of those I keep
  let A [the-house] of the-record

  ask input-realtor [
    ; consider both rent and mortgage
    if [myType] of A = "mortgage" [set sales-sold fput the-record sales-sold]
    if [myType] of A = "rent" [set sales-rent fput the-record sales-rent]

  ]

  if calculate-wealth? = true [
    ; find local houses and store which houses filed the-record
    ;let A-local-houses houses with [distance A <= locality and member? input-realtor local-realtors]
    let A-local-houses (turtle-set [locality-houses] of A) with [member? input-realtor local-realtors]
    ; create a list of the houses that will file the record
    ask the-record [set filed-at-houses [self] of A-local-houses]
    if any? A-local-houses [
      ask A-local-houses [
        let i position input-realtor local-realtors
        ;; add the price of the house to the local realtor
        ;; while at it, remove the nobody elements in the lis (generated when a house dies)
        ;; this saves up run time instead of relooping separately through the lists to remove the nobody variables
        if [myType] of A = "mortgage" [
          let relevant-records item i local-sales
          set relevant-records remove nobody relevant-records
          set relevant-records fput the-record relevant-records
          set local-sales replace-item i local-sales relevant-records
        ]
        ;; add the rent of the house to the local realtor
        if [myType] of A = "rent" [
          let relevant-records item i local-rents
          set relevant-records remove nobody relevant-records
          set relevant-records fput the-record relevant-records
          set local-rents replace-item i local-rents relevant-records
        ]
      ]
    ]
  ]

end

to go
  ;; reset the monitoring parameters
  set nDiscouraged 0
  set nExit 0
  set nEntry 0
  set nForceOutRent 0
  set nForceOutSell 0
  set nForceInSell 0
  set nOwnersOffered 0
  set meanIncomeForceOutRent 0 ;; get mean income of owners who are forced out
  set meanIncomeForceOutSell 0 ;; get mean income of owners who are forced out
  set meanIncomeForceInSell 0

   if ticks = 200 [
    ; Sale market
     if scenario = "ltv"  [ set MaxLoanToValue 60 ]
     if scenario = "raterise 3" [ set InterestRate 3 ]
     if scenario = "raterise 10" [ set InterestRate 10 ]
    ; both
     if scenario = "influx" [ set EntryRate 10 ]
     if scenario = "influx-rev" [ set EXitRate 5 ]
     if scenario = "poorentrants" [ set MeanIncome 24000 ]
    ; rent market?


    if scenario != "base-line" [type "We are at middle of simulation duration, ticks = " type ticks type ", a shock event coming in := " type scenario  print ";"]
  ]

  step  ;; do one time step (a quarter of a year?)

  if not any? owners [ user-message(word "Finished: no remaining people" ) stop ] ;; stop if no owners or houses left
  if not any? houses [ user-message(word "Finished: no remaining houses" ) stop ]
  ;paint-houses
  ;do-plots
  tick
end

to step
  ; reset the count of upshocked and downshocked agents
  reset-globals
  update-visualisation

  let n-owners count owners  ;; take a count of total owners at the moment

  update-income-interestPerTick ; update interest rate and income

  ; owners living in houses
  let owner-occupiers owners with [ is-house? my-house ] ; all owners who are living

  ; change in income due to income shock (all owners)
  ; shock related (possible) effort to change of house of owner occupiers
  shock-management owner-occupiers
  set n-owners count owners  ;; take a count of total owners at the moment
  set owner-occupiers owners with [ is-house? my-house ] ; all owners who are living

  ; owners leaving naturally
  owners-leave n-owners
  set n-owners count owners  ;; take a count of total owners at the moment
  set owner-occupiers owners with [ is-house? my-house ] ; all owners who are living

  ; owners entering naturally
  new-owners n-owners

  set n-owners count owners  ;; take a count of total owners at the moment
  set owner-occupiers owners with [ is-house? my-house ] ; all owners who are living

  ; owners leaving due to discouragement
  manage-discouraged
  set n-owners count owners  ;; take a count of total owners at the moment
  set owner-occupiers owners with [ is-house? my-house ] ; all owners who are living
  let independents owners with [ not is-house? my-house and age = (independenceAge * ticksPerYear) ]
  let occupiers-and-independents (turtle-set owner-occupiers independents)

  ; manage which market the agents enter to on the basis of their current occupation and budgets
  ; manage the market participation of newly independent agents (those leaving their parents houses
  manage-market-participation occupiers-and-independents


  ; introduce new houses
  new-houses

  ; trading and moving into houses
  trade-houses

  ;remove extras (this removes all the offers, but still keeps the houses on the market)
  remove-outdates

  ; demolish old houses
  demolish-houses

  ; decay the prices of houses
  update-prices

  ; update the homeless owners, discourage those who exceed the maxhomelesslimit and manage income/capital
  update-owners

  ; clear the administrators that no longer own any houses
  update-administrators

  ; manage the aging process (age 1 tick, breed, and die)
  if simulate-aging? = true [manage-age]

  ; calculate globals (if needed)
  update-globals
  if force-target = true [manage-targets]

end

to update-income-interestPerTick
  ;;; Calculate Globals

  ;; calc interest per tick ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; add an exogenous cyclical interest rate, if required: varies around mean of
  ; the rate set by slider with a fixed period of 10 years
  set interestPerTick InterestRate / ( TicksPerYear * 100 )
  set interestPerTickBTL InterestRateBTL / (TicksPerYear * 100)
  set interestPerTickFT InterestRateFirstTime / (TicksPerYear * 100)
  set interestPerTickRTB InterestRateRTB / (TicksPerYear * 100)
  ;; add cyclical variation to interest ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if CycleStrength > 0 [
    set interestPerTick interestPerTick * (1 + (CycleStrength / 100 ) * sin ( 36 * ticks / TicksPerYear ))
    set interestPerTickBTL interestPerTickBTL * (1 + (CycleStrength / 100 ) * sin ( 36 * ticks / TicksPerYear ))
    set interestPerTickFT interestPerTickFT * (1 + (CycleStrength / 100 ) * sin ( 36 * ticks / TicksPerYear ))
    set interestPerTickRTB interestPerTickRTB * (1 + (CycleStrength / 100 ) * sin ( 36 * ticks / TicksPerYear ))
  ]



  ;; inflation drive up income ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; add inflation to salary, at inflation rate / TicksPerYear
  if WageRise > 0 [
    ask owners [
      set income income * (1 + (WageRise / ( TicksPerYear * 100 ))) ;; every tick, income stay the same or varied by inflation, income per year
    ]
  ]
end

;; manage random income shocks
to shock-management [oo]
  set nupShocked 0
  set ndownShocked 0
  ; shock frequency is used to produce a random stock not every tick  but with a random frequency
  if random-float 1 < shock-frequency
  [
    ;; change in the income due to shock
    ;; introduce income rise and fall shock to owners ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    let shocked-owners n-of (Shocked / 100 * count owners ) owners ;; gather Shocked% of `owner-occupiers` under `shocked-owners`
    let upshocked n-of (count shocked-owners / 2) shocked-owners ;; gather half of `shocked-owners` under `upshocked`
    ask upshocked [ set income income * (1 + income-shock / 100) ] ;; ask each `upshocked` to increase income by 20%
    let downshocked shocked-owners with [ not member? self upshocked ] ;; gather the non-upshocked as down shocked owners under `downshocked`
    ask downshocked [ set income income * (1 - income-shock / 100 ) ]  ;; ask each downshocked to drop income by 20%

    set nupShocked mean [income] of upShocked
    set ndownShocked mean [income] of downshocked
    set nUpShockedSell count upshocked with [myType = "mortgage"]
    set nDownShockedSell count downshocked with [myType = "mortgage"]
    set nUpShockedRent count upshocked with [myType = "rent"]
    set nDownShockedRent count downshocked with [myType = "rent"]

    ;; income-shock intriges some owners to sell / rent houses ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; after income shock, which type of owners will sell houses due to income rise, and which type of owners sell houses due to income drop
  ]
end

to owners-leave [n-owners]
  ;; owners die or leave naturally ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; every tick, a proportion of owners put their houses on the market and leave town
  let owners-rent owners with [ is-house? my-house and (myType = "rent" or myType = "social") ]
  let nRent min (list count owners-rent (ExitRate * n-owners / (200 * ticksPerYear)))
  set rentLeaveLag rentLeaveLag + nRent - floor nRent
  if rentLeaveLag >= 1 [
    set rentLeaveLag rentLEaveLag - 1
    set nRent nRent + 1
  ]
  ;; manage the leaving houses of rent households
  ask n-of nRent owners-rent [
    ;; manage the tenancy of my-house
    ask my-house [
      if is-owner? offered-to [
        ask offered-to [
          set made-offer-on nobody
          set expected-move-date nobody
        ]
      ]
      set rented-to nobody
      set my-occupier nobody
      set offered-to nobody
      put-on-market
    ]
    ;; remove owner from children of parent
    if is-owner? parent [
      ask parent [
        let index position myself children
        set children replace-item index children nobody
      ]
    ]
    set nExit nExit + 1
    die
  ]

  ;; calculate the number of leaving households of type mortgage
  let owners-mortgage owners with [ is-house? my-house and myType = "mortgage" ]
  let nMortgage min (list count owners-mortgage (ExitRate * n-owners / (200 * ticksPerYear)))
  set mortgageLeaveLag mortgageLeaveLag + nMortgage - floor nMortgage
  if mortgageLeaveLag >= 1 [
    set mortgageLeaveLag mortgageLeaveLag - 1
    set nMortgage nMortgage + 1
  ]
  ask n-of nMortgage owners-mortgage [  ;; ask randomly select (ExitRate% of all owners) number of home-owners to do ...
    ;; Modified to consider cases where a landlord leaves, leading to the eviction of all the tenant
    ; find my-ownership excluding my-house
    let my-ownership-temp turtle-set my-ownership
    ask my-house [set my-ownership-temp other turtle-set my-ownership-temp]

    ask my-ownership-temp [
      ;; If someone is occupying one of my owned houses, evict them
      if is-owner? my-occupier [
        let my-occupier-temp my-occupier
        evict my-occupier-temp
        if not member? "mortgage" [on-market-type] of my-occupier-temp [enter-market my-occupier-temp "rent"]
      ]
      ;; If someone made an offer on one of my owned house and is waiting for the transaction at the expected-move-date, remove the offer
      if is-owner? offered-to [
        ask offered-to [
          set made-offer-on nobody
          set expected-move-date nobody
        ]
      ]
      ;; manage the ownership of the house
      set my-owner nobody
      set my-occupier nobody
      set rented-to nobody
      set offered-to nobody
      ;; put the house on the morgage market (now without an owner as the owner left)
      set myType "mortgage"
      put-on-market
    ]
    ;; manage the ownership of my-house (i.e, the one I live in)
    ask my-house [
      set my-owner nobody
      set my-occupier nobody
      set rented-to nobody
      set offered-to nobody
      ;; put the house on the morgage market (now without an owner as the owner left)
      set myType "mortgage"
      put-on-market
    ]
    ;; remove owner from children of parent
    if is-owner? parent [
      ask parent [
        let index position myself children
        set children replace-item index children nobody
      ]
    ]

    set nExit nExit + 1
    die
  ]

end

;; manage dying agents
to owners-die [owners-to-die]
  ask owners-to-die [
    ;; tenants in pricate and social houses
    if myType = "rent" or myType = "social" [
      ;; manage the tenancy of my-house
      if is-house? my-house [
        ask my-house [
          ;; manage the household making an offer
          if is-owner? offered-to [
            ask offered-to [
              set made-offer-on nobody
              set expected-move-date nobody
            ]
          ]
          set rented-to nobody
          set my-occupier nobody
          set offered-to nobody
          put-on-market
        ]
      ]
      ;; manage the parent parameter of the children of the dying agent
      let i 0
      while [i < length children] [
        if is-owner? item i children [ ask item i children [set parent nobody] ]
        set i i + 1
      ]
      ;; manage cases where the household made an offer on a house in any market
      if is-house? made-offer-on [
        ask made-offer-on [set offered-to nobody]
      ]
      ;; manage the global parameters
      set nExit nExit + 1
      set nDeathsThisTick nDeathsThisTick + 1
      die
    ]

    ;; manage the home owners and landlords
    if myType = "mortgage" [
      let my-ownership-temp nobody
      ifelse my-house != "external"
      ;; find the ownership set without the currently owned house
      [set my-ownership-temp turtle-set my-ownership]
      [
        set my-ownership-temp remove-duplicates my-ownership
        set my-ownership-temp turtle-set remove-item 0 my-ownership-temp
      ]
      if is-house? my-house [
        ask my-house [set my-ownership-temp other turtle-set my-ownership-temp]
      ]

      ;; maange the houses that the hosuehold own but does not occupy
      ask my-ownership-temp [
        ;; If someone is occupying one of my owned houses, evict them
        if is-owner? my-occupier [
          let my-occupier-temp my-occupier
          evict my-occupier-temp
          if not member? "mortgage" [on-market-type] of my-occupier-temp [enter-market my-occupier-temp "rent"]
        ]
        ;; If someone made an offer on one of my owned house and is waiting for the transaction at the expected-move-date, remove the offer
        if is-owner? offered-to [
          ask offered-to [
            set made-offer-on nobody
            set expected-move-date nobody
          ]
        ]
        ;; manage the ownership of the house
        set my-owner nobody
        set my-occupier nobody
        set rented-to nobody
        set offered-to nobody
        ;; put the house on the morgage market (now without an owner as the owner left)
        set myType "mortgage"
        put-on-market
      ]
      ;; manage the ownership of my-house (i.e, the one I live in)
      if is-house? my-house [
        ask my-house [
          ;; manage parameters of owner
          if is-owner? offered-to [
            ask offered-to [
              set made-offer-on nobody
              set expected-move-date nobody
            ]
          ]
          set my-owner nobody
          set my-occupier nobody
          set rented-to nobody
          set offered-to nobody
          ;; put the house on the morgage market (now without an owner as the owner left)
          set myType "mortgage"
          put-on-market
        ]
      ]
      ;; manage the parent parameter of the children of the dying agent
      let i 0
      while [i < length children] [
        if is-owner? item i children [ ask item i children [set parent nobody] ]
        set i i + 1
      ]
      ;; manage cases where the household made an offer on a house in any market
      if is-house? made-offer-on [
        ask made-offer-on [set offered-to nobody]
      ]
      ;; manage global parameters
      set nExit nExit + 1
      set nDeathsThisTick nDeathsThisTick + 1
      die
    ]
  ]

end

to new-owners [n-owners]

  ;; new comers ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; consider cases where entry is less than 1 (common in runs with high interest per tick)
  let totalEntry EntryRate * n-owners / (100 * ticksPerYear)

  ;; a fixed number of new comers enter the city
  repeat totalEntry [
    ;  create-owners EntryRate * n-owners / 100 [  ;; create a fixed proportion of new owners
    create-owners 1 [
      ;; assign type before assigning income
      if new-owner-type = "random" [
        let t random 2
        ifelse t = 0 [set myType "mortgage"] [set myType "rent"]
      ]
      if new-owner-type = "all-rent" [set myType "rent"]
      if new-owner-type = "all-owned" [set myType "mortgage"]
      if new-owner-type = "contextualized" [
        ;; Modified to my-occupier instead of my-owner for representing whether the house is vacant or not
        let x count houses with [myType = "mortgage" and my-occupier = nobody] ; count empty owned houses
        let xx count owners with [mytype = "mortgage" and my-house = nobody] ; owned owners no house
        let y count houses with [myType = "rent" and my-occupier = nobody] ; count empty rent houses
        let yy count owners with [mytype = "rent" and my-house = nobody] ; rent owners no house


        let diff1 x - xx ; if x = 3 and xx = 2, then diff is +ve, meaning owned houses are more than demand and vice versa
        let diff2 y - yy ; if y = 3 and yy = 2, then diff is +ve, meaning rent houses are more than demand and vice versa
        if diff1 <= 0 and diff2 >= 0 [set mytype "rent"] ; owned hosues are less and rent hosues are more/equal than demand, set type rent
        if diff1 <= 0 and diff2 <= 0 [
          let t random 2
          ifelse t = 0 [set myType "mortgage"] [set myType "rent"]
        ] ; owned houses are less and rent hosues are also less, random
        if diff1 >= 0 and diff2 >= 0 [
          let t random 2
          ifelse t = 0 [set myType "mortgage"] [set myType "rent"]
        ] ; both owned and rent houses are more than demand, random
        if diff1 >= 0 and diff2 <= 0 [set myType "mortgage"] ; owned houses are more/equal than demand and rent houses are less, set type owned
      ]

      let force-external-landlord false
      ;; left in case of wanting to add a set of instructiuons for target ratios of types of the new household
      if new-owner-type = "Target ratios" [ ]

      ;; if the new owner should be an external landlord
      ifelse (myType = "mortgage" and random 100 < external-landlords-per-tick and external-landlords? = true)
      or force-external-landlord = true [
        ;; if there are owners on the buy-to-let market
        ifelse any? owners with [on-market-type = ["buy-to-let"] ] [
          ask one-of owners with [on-market-type = ["buy-to-let"] ] [
            ;; create a new owner with the same attributes as one on the buy-to-let market
            ;; this assures the landlord's finances allows for joining the buy-to-let market
            hatch 1 [
              set my-house "external"
              let my-ownership-temp (list)
              foreach my-ownership [h -> set my-ownership-temp lput "external" my-ownership-temp]
              set my-ownership my-ownership-temp
              set breed-age (list)
              set children (list)
              set parent nobody
              hide-turtle
              set on-market-type (list)
              enter-market self "buy-to-let"
              set nEntry nEntry + 1
            ]
          ]
          ;; delete the original agent that was created with the intention of being on the mortgage market
          die
        ]
        ;; if there are no owners on the buy-to-let market
        [
          ;; manage the financial parameters
          assign-income
          set capital medianPriceOfHousesForSale * ((100 - maxLoanToValueBTL) / 100)
          set mortgage (list 0)
          set repayment (list 0)
          set income-rent (list 0)
          set surplus-rent (list 0)
          set rate (list 0)
          set rate-duration (list 0)
          set mortgage-duration (list 0)
          ;; assign the ownership and my-house of the new comer
          set my-ownership (list "external")
          set propensity investors + random-float investors
          set propensity-social random-float 1.0
          set propensity-wait-for-RTB random-float 1.0
          set first-time? False
          set my-house "external"
          set made-offer-on nobody
          set expected-move-date nobody

          ;; Enter the market on the basis of myType
          set on-market-type (list)
          enter-market self "buy-to-let"
          ;; assign the age of the entering agent
          assign-age self
          hide-turtle  ;; new comers have no houses, so they are nowhere to be seen
          set nEntry nEntry + 1
        ]
      ]

      ;; if the new owner should not be an external landlord (applies for mortgage, rent and social type owners)
      [
        set color gray  ;; gray
        set size 0.7  ;; make them visible but not too big

        ;; manage the financial parameters
        ;; assign income normally if no rich immigrants are required
        ifelse myType = "mortgage" and random 100 < rich-immigrants
        [assign-income-rich]  ;; initialize income and capital
        [assign-income]
        set mortgage (list)
        set mortgage-initial (list)
        set mortgage-type (list)
        set repayment (list)
        set income-rent (list)
        set surplus-rent (list)
        set rate (list)
        set rate-duration (list)
        set mortgage-duration (list)

        ;; assign the ownership and my-house of the new comer
        set my-ownership (list)
        set propensity random-float 1.0
        set propensity-social random-float 1.0
        set propensity-wait-for-RTB random-float 1.0
        ;; Enter the market based on myType (i.e., "mortgage" or "rent")
        set on-market-type (list)
        enter-market self myType
        ;; assure the household is not on a waiting list before checking its propensity
        set on-waiting-list? false
        if propensity-social > propensity-social-threshold and myType = "rent" [
          enter-market self "social"
        ]
        ifelse random 100 < FirstTimeBuyersStep
        [set first-time? True]
        [set first-time? False]
        set my-house nobody
        set made-offer-on nobody
        set expected-move-date nobody

        ;; assign the age of the entering agent
        assign-age self
        hide-turtle  ;; new comers have no houses, so they are nowhere to be seen
        set nEntry nEntry + 1
      ]
    ]
  ]

end

to manage-discouraged
  ;; discouraged-leave ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; if an owner without home for too long, it will move out of city
  if maxHomelessPeriod  > 0 [ ; meaning if this value is set
    ask owners with [ not is-house? my-house and my-house != "external" ] [  ;; ask each owner without a house
      set homeless homeless + 1  ;; count the owner's homeless duration
      ;; if homeless duration is beyond limit, this owner will move out of the city (agent die)
      ;; the only exception is if the household has already made an offer and is waiting for the expected-move-date
      if homeless > maxHomelessPeriod and not is-house? made-offer-on [
        set nDiscouraged nDiscouraged + 1
        die
      ]
    ]
    ;; manage public sectors waiting list
    ask public-sectors [set waiting-list remove nobody waiting-list]
    ;; manage external landlords
    ask owners with [ my-house = "external" and on-market-type = ["buy-to-let"] ] [
      set homeless homeless + 1
      let my-ownership-temp remove-duplicates my-ownership
      if length my-ownership-temp = 1 and homeless > maxHomelessPeriod and not is-house? made-offer-on [
        set homeless 0
        set on-market-type (list)
      ]
    ]
  ]
  ;; manage external households that get discouraged
  ask owners with [ my-house = "external" and on-market-type = (list) ] [
    let my-ownership-temp remove-duplicates my-ownership
    if length my-ownership-temp = 1 [die]
  ]


  ;; if an `owner` is trying to invest on the BTL market for too long, it gets discouraged
  ;; if maximumPeriodBTL is higher than 0 - meaning the variable is set
  if onMarketPeriodBTL > 0 [
    ask owners with [member? "buy-to-let" on-market-type and made-offer-on = nobody] [
      ;; if the household spent a long period on the market, leave it and enter the cooldown process
      if time-on-market >= onMarketPeriodBTL [
        set on-market? false
        set on-market-type remove "buy-to-let" on-market-type
        set time-on-market 0
        set on-cooldown? true
        set on-cooldown-type "buy-to-let"
        set time-on-cooldown 0
      ]
    ]
  ]

  ;; if maximumPeriodMortgage is higher than 0 - meaning the variable is set
  if onMarketPeriodMortgage > 0 [
    ask owners with [member? "mortgage" on-market-type and made-offer-on = nobody] [
      ;; if the household spent a long period on the market, leave it and enter the cooldown process
      if time-on-market >= onMarketPeriodMortgage [
        set on-market? false
        set on-market-type remove "mortgage" on-market-type
        set time-on-market 0
        set on-cooldown? true
        set on-cooldown-type "mortgage"
        set time-on-cooldown 0
      ]
    ]
  ]

end

;; manage well-off and not well-off turtles of type 'owners'
to manage-market-participation [input-owners]
  ;;; manage not-well-off owners (i.e., those not being able to pay repayments or rent)
  ;; evict mortgage and rent
  ; poorer owners with myType = mortgage
  let not-well-off-mortgage input-owners with [on-market? = false and is-house? my-house and myType = "mortgage" and (sum (repayment) * TicksPerYear) > (eviction-threshold-mortgage * ( (income * Affordability / 100) + (sum (income-rent) * TicksPerYear)))]
  ; poorer owners with myType = mortgage and only one house (these will be evicted)
  let not-well-off-mortgage-evict not-well-off-mortgage with [count turtle-set my-ownership <= 1]
  ; poorer owners with myType = rent (these will always be evicted)
  let not-well-off-rent input-owners with [on-market? = false and is-house? my-house and myType = "rent" and (my-rent * TicksPerYear) > (eviction-threshold-rent * income * Affordability-rent / 100)]
  ; poorer owners with myType = social (these will be evicted)
  let not-well-off-social input-owners with [on-market? = false and is-house? my-house and myType = "social" and (my-rent * TicksPerYear) > (eviction-threshold-social * income * Affordability-rent / 100)]
  ; create a set of all the owners that will be evicted
  let not-well-off-evict (turtle-set not-well-off-mortgage-evict not-well-off-rent not-well-off-social)
  ; categorise based on the market that they will join ("social" or "rent")
  let not-well-off-evict-to-social not-well-off-evict with [propensity-social > propensity-social-threshold and income <= run-max-income-social]
  let not-well-off-evict-to-rent not-well-off-evict with [propensity-social <= propensity-social-threshold or income > run-max-income-social]
  ; evict and enter rent market
  if any? not-well-off-evict-to-rent [
    evict not-well-off-evict-to-rent
    enter-market not-well-off-evict-to-rent "rent"
  ]
  ; evict and enter both the private rent and social markets
  if any? not-well-off-evict-to-social [
    evict not-well-off-evict-to-social
    enter-market not-well-off-evict-to-social "rent"
    enter-market not-well-off-evict-to-social "social"
  ]

  ;; force mortgage with more than one ownership to sell one of his ownership
  ; poorer owners with myType = mortgage and mare than one house (these will stay and will only sell one of their houses) and without any house already on sale (if a house is on sale, then this owner is waiting for the sale to happen to make profit and stop being not-well-off
  let not-well-off-mortgage-stay not-well-off-mortgage with [count turtle-set my-ownership > 1 and count ( (turtle-set my-ownership) with [for-sale? = true] ) = 0 and count ( (turtle-set my-ownership) with [for-rent? = true] ) = 0]

  ; force a rent increase and check if the tenant will be able to pay
  if any? not-well-off-mortgage-stay [
    force-sell-rent not-well-off-mortgage-stay
  ]

  ;; previous not-well-off that were able to recover
  let not-well-off-recovered input-owners with [not-well-off? = true and (sum (repayment) * TicksPerYear) <= (eviction-threshold-mortgage * ((income * Affordability / 100) + (sum (income-rent) * TicksPerYear)))]
  ask not-well-off-recovered [
    set not-well-off? false
    set not-well-off-period 0
  ]

  ;; well off mortgage and rent
  let well-off-mortgage input-owners with [
    on-market? = false
    and is-house? my-house
    and myType = "mortgage"
    and (capital >= (median (mortgage)) * ( 1 - (MaxLoanToValueBTL / 100) ))
    and ( (((income * Affordability / 100)  + (sum(income-rent) * TicksPerYear)) ) - ((sum repayment) * TicksPerYear) > (median(repayment) * TicksPerYear) )]
  ;; sale price * MaxLTV / 100 --> the expected mortgage value
  ;; sale price * (1 - (MaxLTV / 100)) --> the expected deposit
  let well-off-rent input-owners with [
    on-market? = false
    and is-house? my-house
    and myType = "rent"
    and ( ( first-time? = False and capital + capital-parent >= (savings-to-rent-threshold * [sale-price] of my-house * (1 - (MaxLoanToValue / 100))) ) or ( first-time? = True and capital + capital-parent >= (savings-to-rent-threshold * [sale-price] of my-house * (1 - (MaxLoanToValueFirstTime / 100)))) )
    ;; assure the max LTV used is based on being a first-time buyer or not
    and ( ( first-time? = False and ((income * Affordability / 100) > [sale-price] of my-house * (MaxLoanToValue / 100) * interestPerTick / (1 - ( 1 + interestPerTick ) ^ ( - MortgageDuration * TicksPerYear))) ) or (first-time? = True and ((income * Affordability / 100) > [sale-price] of my-house * (MaxLoanToValueFirstTime / 100) * interestPerTickFT / (1 - ( 1 + interestPerTickFT ) ^ ( - MortgageDurationFirstTime * TicksPerYear)))) )
    and ( ( first-time? = False and (income * MaxLoanToIncome) + (capital + capital-parent) >= [sale-price] of my-house ) or ( first-time? = True and (income * MaxLoanToIncomeFT) + (capital + capital-parent) >= [sale-price] of my-house ) )
  ]
  ; assure no agent is counted twice as well-off and not-well-off
  ask not-well-off-mortgage [set well-off-mortgage other well-off-mortgage]
  ask not-well-off-rent [set well-off-rent other well-off-rent]
  ;; put the agents on the market
  if any? well-off-mortgage [
    ask well-off-mortgage [
      if propensity > (1 - investors) and on-cooldown? = false [enter-market self "buy-to-let"]
    ]
  ]
  if any? well-off-rent [
    ask well-off-rent [
      if propensity > (1 - upgrade-tenancy) [enter-market self "rent"]
      if propensity <= (1 - upgrade-tenancy) and on-cooldown? = false [
        ;; remove myself from social housing market
        if on-waiting-list? [exit-social self]
        enter-market self "mortgage"
      ]
    ]
  ]


  ;; well-off social
  let well-off-social no-turtles
  let right-to-buy-social no-turtles
  ifelse right-to-buy? = true [
    ;; households of type "social" that become relatively rich BEFORE they can buy their social house
    set well-off-social input-owners with [
      propensity-wait-for-RTB < propensity-wait-for-RTB-threshold
      and on-market? = false
      and is-house? my-house
      and myType = "social"
      and time-in-social-house < (right-to-buy-threshold * ticksPerYear)
      and ( ( first-time? = False and capital + capital-parent >= (savings-to-rent-threshold * ([sale-price] of my-house / 0.35 ) * (1 - (MaxLoanToValue / 100))) ) or ( first-time? = True and capital + capital-parent >= (savings-to-rent-threshold * ([sale-price] of my-house / 0.35) * (1 - (MaxLoanToValueFirstTime / 100)))) )
      and ( ( first-time? = False and ( (income * Affordability / 100) > ([sale-price] of my-house / 0.35) * (MaxLoanToValue / 100) * interestPerTick / (1 - ( 1 + interestPerTick ) ^ ( - MortgageDuration * TicksPerYear))) ) or (first-time? = True and ((income * Affordability / 100) > ([sale-price] of my-house / 0.35) * (MaxLoanToValueFirstTime / 100) * interestPerTickFT / (1 - ( 1 + interestPerTickFT ) ^ ( - MortgageDurationFirstTime * TicksPerYear)))) )
      and ( ( first-time? = False and (income * MaxLoanToIncome) + (capital + capital-parent) >= [sale-price] of my-house ) or ( first-time? = True and (income * MaxLoanToIncomeFT) + (capital + capital-parent) >= [sale-price] of my-house ) )
    ]
    ;; households of type "social" that become relatively rich AFTER they can buy their social house
    set right-to-buy-social input-owners with [
      on-market? = false
      and is-house? my-house
      and myType = "social"
      and time-in-social-house >= (right-to-buy-threshold * ticksPerYear)
      and capital + capital-parent >= (savings-to-social-threshold * [sale-price] of my-house * (1 - (MaxLoanToValue / 100)))
      and ((income * Affordability / 100) > [sale-price] of my-house * (MaxLoanToValueRTB / 100) * interestPerTickRTB / (1 - ( 1 + interestPerTickRTB ) ^ ( - MortgageDuration * TicksPerYear)))
      and (income * MaxLoanToIncomeRTB) + (capital + capital-parent) >= [sale-price] of my-house
    ]
    ;; put the agents on the market
    if any? well-off-social [
      ask well-off-social [
        if on-waiting-list? [exit-social self]
        enter-market self "mortgage"
      ]
    ]
    ;; put the agents on the RTB market (they will try to buy their occupied house)
    if any? right-to-buy-social [
      ask right-to-buy-social [
        enter-market self "right-to-buy"
        ask my-house [
          put-on-market
        ]
      ]
    ]
  ]
  ;; right-to-buy? = false
  [
    ;; households of type "social" that become relatively rich BEFORE they can buy their social house
    set well-off-social input-owners with [
      on-market? = false
      and is-house? my-house
      and myType = "social"
      and time-in-social-house < (right-to-buy-threshold * ticksPerYear)
      and ( ( first-time? = False and capital + capital-parent >= (savings-to-rent-threshold * ([sale-price] of my-house / 0.35 ) * (1 - (MaxLoanToValue / 100))) ) or ( first-time? = True and capital + capital-parent >= (savings-to-rent-threshold * ([sale-price] of my-house / 0.35) * (1 - (MaxLoanToValueFirstTime / 100)))) )
      and ( ( first-time? = False and ((income * Affordability / 100) > ([sale-price] of my-house / 0.35) * (MaxLoanToValue / 100) * interestPerTick / (1 - ( 1 + interestPerTick ) ^ ( - MortgageDuration * TicksPerYear))) ) or (first-time? = True and ((income * Affordability / 100) > ([sale-price] of my-house / 0.35) * (MaxLoanToValueFirstTime / 100) * interestPerTickFT / (1 - ( 1 + interestPerTickFT ) ^ ( - MortgageDurationFirstTime * TicksPerYear)))) )
    ]
    ;; put the agents on the market
    if any? well-off-social [
      ask well-off-social [
        if on-waiting-list? [exit-social self]
        enter-market self "mortgage"
      ]
    ]
  ]

  let independent nobody
  let independent-rent nobody
  let independent-mortgage nobody
  if simulate-aging? = true [
    ;; recently independent agents with no house yet
    set independent input-owners with [ not is-house? my-house and on-market? = false ]
    ;; independent agents joining the mortgage market
    set independent-mortgage independent with [
      capital + capital-parent >= ( savings-to-rent-threshold * [average-price] of one-of realtors * (1 - (MaxLoanToValueFirstTime / 100)) )
      and (income * Affordability / 100) > [average-price] of one-of realtors * (MaxLoanToValueFirstTime / 100) * interestPerTickFT / (1 - ( 1 + interestPerTickFT ) ^ ( - MortgageDurationFirstTime * TicksPerYear))
    ]
    ;; independent agents joining the rent market
    set independent-rent independent
    if any? independent-mortgage [ask independent-mortgage [set independent-rent other independent-rent]]

    ;; put the agents on the market and exit the waiting list
    if any? independent-mortgage [
      ask independent-mortgage [
        if on-waiting-list? [exit-social self]
        enter-market self "mortgage"
      ]
    ]
    ;; put the agents on the rent market
    if any? independent-rent [
      ask independent-rent [enter-market self "rent"]
    ]
  ]


  ;; manage globals
  if not any? not-well-off-mortgage [
    set nEvictedMortgageOneHouse 0
    set nEvictedMortgageMoreHouses 0
  ]
  ifelse any? not-well-off-mortgage-evict                      [set nEvictedMortgage count not-well-off-mortgage-evict] [set nEvictedMortgage 0]
  ifelse any? (turtle-set not-well-off-evict independent-rent) [set nEnterMarketRent count (turtle-set not-well-off-evict independent-rent)    set nHomeless count not-well-off-evict] [set nEnterMarketRent 0     set nHomeless 0]
  ifelse any? (turtle-set well-off-rent independent-mortgage)  [set nEnterMarketMortgage count well-off-rent] [set nEnterMarketMortgage 0]
  ifelse any? (turtle-set independent-rent)                    [set nIndependentRent count independent-rent] [set nIndependentRent 0]
  ifelse any? (turtle-set independent-mortgage)                [set nIndependentMortgage count independent-mortgage] [set nIndependentMortgage 0]
  ifelse any? well-off-mortgage                                [set nEnterMarketBuyToLet count well-off-mortgage] [set nEnterMarketBuyToLet 0]
  ifelse any? not-well-off-mortgage-stay                       [set nForceSell count not-well-off-mortgage-stay] [set nForceSell 0]
  ifelse any? not-well-off-mortgage-evict                      [set meanIncomeEvictedMortgage mean [income] of not-well-off-mortgage-evict] [set meanIncomeEvictedMortgage 0]
  ifelse any? not-well-off-rent [
    set nEvictedRent count not-well-off-rent
    set meanIncomeEvictedRent mean [income] of not-well-off-rent
  ]
  [
    set nEvictedRent 0
    set meanIncomeEvictedRent 0
  ]

end

;; evict occupiers from their houses (rented or mortgaged)
to evict [occupiers]
  ask occupiers [
    ;; if I am occupying a "mortgage" house (i.e., I own my house and live in it)
    if [myType] of my-house = "mortgage" [
      ;; manage my-house ownership parameters
      ask my-house [
        ;; 19.0.20
        ;; if someone made an offer on the house
        if is-owner? offered-to [
          ask offered-to [
            set made-offer-on nobody
            set expected-move-date nobody
          ]
        ]
        set my-occupier nobody
        set my-owner nobody
        set rented-to nobody
        ;; put the house in the "mortgage" market, now without an owner as the owner is being evicted
        put-on-market
      ]
      ;; find all my-ownership without including my-house
      let my-ownership-temp turtle-set my-ownership
      ask my-house [set my-ownership-temp other turtle-set my-ownership-temp]
      ;; address my-ownership without addressing my-house
      ask turtle-set my-ownership-temp [
        ;; If the ownership is a rented property
        if myType = "rent" [
          ;; 19.0.20
          ;; if someone made an offer on the house
          if is-owner? offered-to [
            ask offered-to [
              set made-offer-on nobody
              set expected-move-date nobody
            ]
          ]
          ;; and the ownership has an occupier
          if is-owner? my-occupier [
            ;; evict the occupier
            let my-occupier-temp my-occupier
            evict my-occupier-temp
            ;enter-market my-occupier-temp "rent"
            if not member? "mortgage" [on-market-type] of my-occupier-temp [enter-market my-occupier-temp "rent"]
          ]
          ;; manage ownership parameters and put the house on the mortgage market (with no owner)
          set myType "mortgage"
          set my-occupier nobody
          set my-owner nobody
          set rented-to nobody
          put-on-market
        ]
        ;; if my-ownership is a mortgage house (meaning it is on-sale? on the mortgage market)
        if myType = "mortgage" [
          ;; 19.0.20
          ;; if someone made an offer on the house
          if is-owner? offered-to [
            ask offered-to [
              set made-offer-on nobody
              set expected-move-date nobody
            ]
          ]
          ;; address the ownership parameters
          set my-occupier nobody
          set my-owner nobody
          set rented-to nobody
          set offered-to nobody
          ;; put the ownership back on the market, but now without an owner
          put-on-market
        ]
      ]
      ;; assure the owner being evicted now has no house and no ownership
      set my-house nobody
      set my-ownership (list)
      set mortgage (list)
      set mortgage-initial (list)
      set mortgage-type (list)
      set repayment (list)
      set income-rent (list)
      set surplus-rent (list)
      ;; assure the owners leaves the markets (particularly, in case it was on the "buy-to-let" market)
      set on-market? false
      set on-market-type (list)
      ;; assure the homeless count is set back to 0
      set homeless 0
      stop
    ]

    ;; if I am living in a rented house
    if [myType] of my-house = "rent" [
      ;; put my house back on the rented market without an occupier
      ask my-house [
        ;; 19.0.20
        ;; if someone made an offer on the house
        if is-owner? offered-to [
          ask offered-to [
            set made-offer-on nobody
            set expected-move-date nobody
          ]
        ]
        set my-occupier nobody
        set rented-to nobody
        put-on-market
      ]
      ;; assure the landlord decreases their income-rent due to the eviction of a tenant
      let landlord [my-owner] of my-house
      if is-owner? landlord [
        let index-temp position my-house [my-ownership] of landlord
        ask landlord [
          set income-rent replace-item index-temp income-rent 0
          set surplus-rent replace-item index-temp surplus-rent (0 - item index-temp repayment)
        ]
      ]
      ;; assure I now have no house and set homeless to 0
      set my-house nobody
      set homeless 0
      stop
    ]

    ;; if I am living in a social house
    if [myType] of my-house = "social" [
      ask my-house [
        ;; 19.0.20
        ;; if someone made an offer on the house
        if is-owner? offered-to [
          ask offered-to [
            set made-offer-on nobody
            set expected-move-date nobody
          ]
        ]
        set my-occupier nobody
        set rented-to nobody
        put-on-market
      ]
      set my-house nobody
      set homeless 0
    ]
    hide-turtle
  ]
end

to force-sell-rent [sellers]
  ask sellers [
    ;; find all the ownership that is not the house I live in (this is to avoid selling the house I occupy and becoming homeless)
    let my-ownership-temp turtle-set my-ownership
    let surplus-rent-temp remove-item 0 surplus-rent
    let house-to-sell nobody
    let house-to-rent nobody
    ask my-house [set my-ownership-temp other turtle-set my-ownership-temp]
    (ifelse
      any? my-ownership-temp with [for-rent? = true and on-market-period >= maxForRentPeriodPoorLandlord] [
        set house-to-sell one-of my-ownership-temp with [for-rent? = true and on-market-period >= maxForRentPeriodPoorLandlord]
      ]
      ;; if no houses are offered for rent (all occupied), offer the house with the lowest rent profit on the rent market again
      not any? my-ownership-temp with [for-rent? = true] [
        ;type self type " | surplus-rent = " type surplus-rent type " | my-ownership = " type my-ownership type "\n"
        let index-temp position (min surplus-rent-temp) surplus-rent
        set house-to-rent item index-temp my-ownership
      ]

    )

    if any? turtle-set house-to-sell [
      ;; manage house to sell
      ask house-to-sell [
        if is-owner? my-occupier [
          let my-occupier-temp my-occupier
          evict my-occupier-temp
          enter-market my-occupier-temp "rent"
        ]
        set myType "mortgage"
        put-on-market
      ]
    ]

    if any? turtle-set house-to-rent [
      ;; manage house to rent
      ask house-to-rent [
        if is-owner? my-occupier [
          let my-occupier-temp my-occupier
          evict my-occupier-temp
          enter-market my-occupier-temp "rent"
        ]
        set myType "rent"
        put-on-market
      ]
    ]
  ]

end

;; force seller to put one of their ownership on the amrket (only triggered when a landlord is not well-off and needs to sell)
;; not used in the current version of the model
to force-sell [sellers]
  ask sellers [
    ; if the landlord lives outside the simulated system
    ifelse my-house = "external" [
      let house-to-sell nobody
      let i 1
      let surplus (list 0)
      while [i < length my-ownership] [
        ifelse item i my-ownership != "external" [
          let mortgage-temp item i mortgage
          let price-temp [sale-price] of item i my-ownership
          set surplus lput (price-temp - mortgage-temp) surplus
        ]
        [
          set surplus lput 0 surplus
        ]
        set i i + 1
      ]
    ]
    ;; if the landlord lives in the simulated system
    [
      ;; find all the ownership that is not the house I live in (this is to avoid selling the house I occupy and becoming homeless)
      let my-ownership-temp turtle-set my-ownership
      let house-to-sell nobody
      ask my-house [set my-ownership-temp other turtle-set my-ownership-temp]
      ;; if there is a house that is not for sale and is not rented, sell that house
      ifelse any? my-ownership-temp with [for-sale? = false and rented-to = nobody] [
        set house-to-sell one-of my-ownership-temp with [for-sale? = false and rented-to = nobody]
      ]
      ;; if all the houses are rented, check the one that will yield the highest capital and sell it
      [
        ;; start from index 1 as the first item in the list is always my-house
        let i 1
        ;; set a list with one element 0 (reflecting no benefit from selling own house)
        let surplus (list 0)
        ;; loop into the ownership to create a list of surplus values
        while [i < length my-ownership] [
          let mortgage-temp item i mortgage
          let price-temp [sale-price] of item i my-ownership
          set surplus lput (price-temp - mortgage-temp) surplus
          set i i + 1
        ]
        ;; select the ownership leading to the highest surplus
        let index-temp position max(surplus) surplus
        ;; Make sure the owner does not sell its my-house if the surplus is negative for all the other houses
        if index-temp = 0 [
          let surplus-temp remove-item 0 surplus
          set index-temp position max(surplus-temp) surplus
        ]
        set house-to-sell item index-temp my-ownership
      ]

      if any? turtle-set house-to-sell [
        ;; manage the parameters of the houses to be sold and their occupiers (if any)
        ask house-to-sell [
          if is-owner? my-occupier [
            let my-occupier-temp my-occupier
            evict my-occupier-temp
            if not member? "mortgage" [on-market-type] of my-occupier-temp [enter-market my-occupier-temp "rent"]
          ]
          set myType "mortgage"
          put-on-market
        ]
      ]
    ]

  ]

end

;; enter the market for mortgage or rent
to enter-market [candidates market-type]
  ask candidates [
    ;; manage cooldown
    set on-cooldown? false
    set time-on-cooldown 0
    set time-on-market 0
    ;; enter the market
    set on-market? true
    set on-market-type lput market-type on-market-type
  ]
end

;; exit the social market (i.e., leave the waiting list)
to exit-social [candidates]
  ask candidates [
    set on-waiting-list? false
    set on-market-type remove "social" on-market-type
    ask public-sectors [set waiting-list remove myself waiting-list]
  ]
end

to new-houses
  ;; calculate the number of social and mortgage hosues to build
  let nSocial (count houses * HouseConstructionRate / (100 * ticksPerYear)) * (new-social-houses / 100)
  let nMortgage (count houses * HouseConstructionRate / (100 * ticksPerYear)) * (1 - (new-social-houses / 100))
  ;; account for the fractions of houses that were built this tick
  set socialConstructionLag socialConstructionLag + nSocial - floor nSocial
  set mortgageConstructionLag mortgageConstructionLag + nMortgage - floor nMortgage

  ;; Lag represnts the fractions of houses that should have been build in the previous steps
  ;; when it reaches 1, an extra house is constructed
  ;; necessary at high ticksPerYear runs as the number of constructed houses per tick can fall below 1
  if socialConstructionLag >= 1 [
    set nSocial nSocial + 1
    set socialConstructionLag socialConstructionLag - 1
  ]
  if mortgageConstructionLag >= 1 [
    set nMortgage nMortgage + 1
    set mortgageConstructionLag mortgageConstructionLag - 1
  ]
   ;; some new houses are built, and put up for sale ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  repeat nSocial [
    if any? patches with [ not any? houses-here ] and count houses / count patches < MaxDensity / 100  [build-house "social"]
  ]
  ;; build a fixed proportion of new mortgagehouses
  repeat nMortgage [
    if any? patches with [ not any? houses-here ] and count houses / count patches < MaxDensity / 100  [build-house "mortgage"]
  ]
  reset-empty-houses ; set sale and rent price

  ask houses with [ quality = 0 ] [ ;; ask each house with quality = 0
      let houses-around-here other houses in-radius Locality
      ;; put ( the other houses which are within the radius circle where the current house is the center ) under `houses-around-here`
      set quality ifelse-value any? houses-around-here ;; if `houses-around-here` exist, then return first value to `quality`
        [ mean [ quality ] of houses-around-here ]
        [ 1 ]                                          ;; if `houses-around-here` exist, then return second value to `quality`
      if quality > 3 [set quality 3]  ;; quality has upper limit to be 3
      if quality < 0.3 [set quality 0.3]  ;; quality has lower limit to be 0.3
  ]

end

;; make offers and move to a new house if the cahin checks out
to trade-houses
  let houses-for-sale houses with [ for-sale? = true and not is-owner? offered-to]                                  ;; find all the houses for sale
  let houses-for-rent houses with [ for-rent? = true and not is-owner? offered-to]
  let houses-for-social houses with [ for-social? = true and not is-owner? offered-to]
  let houses-for-rightToBuy houses with [for-rightToBuy? = true and not is-owner? offered-to]
  value-houses houses-for-sale houses-for-rent houses-for-social houses-for-rightToBuy

  ;; we check here whether houses are on-market or not (as this is a decision that should have been premade by the owner)
  let buyers-with-offers owners with [on-market? = true and is-house? made-offer-on]
  let buyers-without-offers owners with [on-market? = true and not is-house? made-offer-on]
  let buyers owners with [ on-market? = true]  ;; put all owners who don't have a house or whose houses on sale under `buyers`

  make-offers buyers-without-offers houses-for-sale houses-for-rent houses-for-social
  ;; if a deal is made, then households will move in and out of houses
  set moves 0                                                                        ;; the number of households moving in this step

  ;; ask public sectors
  ask public-sectors [
    if length vacant-houses > 0 and length waiting-list > 0 [
      assign-social-housing
    ]
  ]
  ;ask buyers with [ is-house? made-offer-on and on-market? = true and expected-move-date = ticks and on-market-type = ["social"]] [
  ask buyers-with-offers with [ expected-move-date <= ticks and on-market-type = ["social"]] [
    move-house self
    set buyers-with-offers other buyers-with-offers
  ]

  ;; If a buyer has made an offer and it is time for a transaction to happen, check the transaction chains and move to the new house
  ;ask buyers with [ is-house? made-offer-on and on-market? = true and expected-move-date = ticks and on-market-type != ["social"]] [           ;; ask buyers who have no houses and made offer on a house
  ask buyers-with-offers with [ expected-move-date <= ticks] [           ;; ask buyers who have no houses and made offer on a house
                                                                               ;; self is buyer, and check whether the buy-sell chain is intact or not
    ;; if intact, deal is made, and households move out and into houses, count the number of moves
    let chain-status follow-chain self self
    (ifelse
      chain-status = true [move-house self]
      ;; if not intact deal, cancel offer and expected move date
      chain-status = false [
        set made-offer-on nobody
        set expected-move-date nobody
      ]
      ;; else, the expected-move-date is delayed
      is-number? chain-status [
        set expected-move-date chain-status
      ]
    )


  ]

end

;; assign social housing to households on the waiting list
;; prublic sector function
to assign-social-housing
  let waiting-list-temp turtle-set waiting-list
  let vacant-houses-temp turtle-set vacant-houses
  let homeless-waiting waiting-list-temp with [not is-house? my-house]
  let occupiers-waiting waiting-list-temp with [is-house? my-house]

  ;; address all the vacant social houses
  ask vacant-houses-temp [
    let assigned? false
    let assigned nobody
    ;; prioritise homeless households
    if any? homeless-waiting [
      let eligible-homeless homeless-waiting with [ income * Affordability-rent / (ticksPerYear * 100 ) >= [rent-price] of myself ]
      if any? eligible-homeless [
        ;; select the homeless with the lowest income
        ask eligible-homeless with [income = min [income] of eligible-homeless] [
          ;; assure the household is now only on the social housing market
          set on-market-type ["social"]
          set made-offer-on myself
          set expected-move-date ticks + ((social-lag / 12) * ticksPerYear)
          ;move-house self
          set assigned self
          set assigned? true
        ]
      ]
    ]
    ;; Find all the households on the waiting list that can pay the rent of the vacant houses
    let eligible-occupiers occupiers-waiting with [ income * Affordability-rent / (ticksPerYear * 100 ) >= [rent-price] of myself ]
    if any? eligible-occupiers and assigned? = false [
      ask eligible-occupiers with [income = min [income] of eligible-occupiers] [
        ;; assure the household is now only on the social housing market
        set on-market-type ["social"]
        set made-offer-on myself
        set expected-move-date ticks + ((social-lag / 12) * ticksPerYear)
        set assigned self
        set assigned? true
      ]
    ]

    if assigned? = true [
      ;; remove the owner and house from the public sector lists
      ask my-owner [
        set vacant-houses remove myself vacant-houses
        set waiting-list remove assigned waiting-list
      ]
      ;; remove the assigned household from the waiting list and recreate the homeless-waiting and occupiers-waiting
      ask assigned [
        set waiting-list-temp other waiting-list-temp
        set homeless-waiting other homeless-waiting
        set occupiers-waiting other occupiers-waiting
      ]
    ]
  ]

end


to value-houses [houses-for-sale houses-for-rent houses-for-social houses-for-rightToBuy]
  ;; value-houses ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; initially, house sale-price is added up by mortgage and deposit in setup
  ;; once a house put on sale, sale-price, my-realtor (house) , average-price (realtor), median price for all houses on sale, are to be updated.
  ;; because sellers will ask all local-realtors to value the house again and the seller will choose my-realtor again to update the sale-price
  if any? houses-for-sale [                                                      ;; if these houses exist
    ask houses-for-sale with [ date-for-sale = ticks ] [                         ;; ask each of those houses which are just on sale from now on
      set my-realtor max-one-of turtle-set local-realtors [ valuation myself ]               ;; set the realtor gives the current house the highest valuation to be my-realtor
      set sale-price [ valuation myself ] of my-realtor                           ;; take the highest value valuation price as sale-price of the current house
    ]                                                                                   ;; update the average-price of each realtor
    ask realtors [                                                                 ;; ask each realtor
      let my-houses-for-sale houses-for-sale with [ member? myself local-realtors and myType = "mortgage"] ;; get all houses under this realtor
      if any? my-houses-for-sale [ set average-price median [ sale-price ] of my-houses-for-sale ]
                                                        ;; if these houses exist, take their median price as the realtor's average-price for its all houses
    ]
    set medianPriceOfHousesForSale median [sale-price] of houses-for-sale
  ]

  if any? houses-for-rent [                                                      ;; if these houses exist
    ask houses-for-rent with [ date-for-rent = ticks ] [                         ;; ask each of those houses which are just on sale from now on
;      type "!!! " type self type " offered to " type offered-to type " is in value-houses set houses-for-rent\n"
      set my-realtor max-one-of turtle-set local-realtors [ valuation myself ]               ;; set the realtor gives the current house the highest valuation to be my-realtor
      ;; Modified to rent-price
      set rent-price [ valuation myself ] of my-realtor                           ;; take the highest value valuation price as sale-price of the current house
      ;; Assure rent price is higher than the repayment
      let i position self [my-ownership] of my-owner
      let repayment-temp (item (i) ([repayment] of my-owner))
      if rent-price < ( repayment-temp * (RentToRepayment / 100) ) [
        set rent-price (repayment-temp * (RentToRepayment / 100))
      ]
    ]                                                                                  ;; update the average-price of each realtor
    ask realtors [                                                                 ;; ask each realtor
      let my-houses-for-rent houses-for-rent with [ member? myself local-realtors and myType = "rent"] ;; get all houses under this realtor
      ;; Modified to median of rent-price
      if any? my-houses-for-rent [ set average-rent median [ rent-price ] of my-houses-for-rent ] ;; if these houses exist, take their median price as the realtor's average-price for its all houses
    ]
    ;; Modified to rent-price
    set medianPriceOfHousesForRent median [rent-price] of houses-for-rent           ;; update median price of all houses on sale
  ]

  if any? houses-for-social [
    ask houses-for-social with [ date-for-social = ticks ] [                         ;; ask each of those houses which are just on sale from now on
      set my-realtor max-one-of turtle-set local-realtors [ valuation myself ]               ;; set the realtor gives the current house the highest valuation to be my-realtor
      ;; Valuation function decreases the rent-price of social houses
      set rent-price [ valuation myself ] of my-realtor                         ;; take the highest value valuation price as sale-price of the current house
      ;; Assure rent price is higher than the repayment
      let i position self [my-ownership] of my-owner
    ]                                                                                  ;; update the average-price of each realtor
    ;; Modified to rent-price
    set medianPriceOfHousesForSocial median [rent-price] of houses-for-social           ;; update median price of all houses on sale
  ]

  if any? houses-for-rightToBuy [
    ask houses-for-rightToBuy with [ date-for-rightToBuy = ticks ] [                         ;; ask each of those houses which are just on sale from now on
      set my-realtor max-one-of turtle-set local-realtors [ valuation myself ]               ;; set the realtor gives the current house the highest valuation to be my-realtor
      set sale-price [ valuation myself ] of my-realtor                           ;; take the highest value valuation price as sale-price of the current house
      ;; Update median right-to-buy price
      set medianPriceOfHousesForRightToBuy median [sale-price] of houses-for-rightToBuy
    ]
  ]
end

to-report valuation [ property ]    ;; realtor procedure
                                    ;; valuation house price by realtor ;;
  let normalization 1  ;; create a local variable normalization
  let multiplier [ quality ] of property * (1 + RealtorOptimism / 100) * normalization         ;; create a multiplier for final finish of valuation price ;; component of multiplier include quality, optimism, normalization

  let old-price [sale-price] of property  ;; set the input house's sale-price as old price
  let old-rent [rent-price] of property
  let new-price 0  ;; create a new price variable with 0 value
  let new-rent 0
  let ptype [myType] of property

  ; if calculate-wealth? is true, use the saved lists of houses and records in houses (saves run time)
  ifelse calculate-wealth? = true [
    let i position self [local-realtors] of property
    let local-sales-sold item i [local-sales] of property
    let local-sales-rent item i [local-rents] of property
    let plocality [locality-houses] of property

    if (ptype = "mortgage") or (ptype = "social" and [for-rightToBuy?] of property = true) [ ; owned
      ifelse any? turtle-set local-sales-sold  ;; if the local-sales exist
      [
        set new-price median [ selling-price ] of turtle-set local-sales-sold
        if ptype = "social" [
          ;; find the number of ticks beyond 5 years that through which the household occupied a social house
          let time-for-extra-discount max ( (list 0 (([time-in-social-house] of ([my-occupier] of property) / ticksPerYear) - 5)) )
          ;; find the total discount (35% plus 1% for every year spent in a social house beyond 5 years, at a maximum of 70% or £102,000)
          ;; reference https://www.gov.uk/right-to-buy-buying-your-council-home/discounts
          let discount-percent min ( (list 0.7 (0.35 + (0.1 * time-for-extra-discount))) )
          ;; maximum discount value must not exceed £102,400
          let discount-price min ( list (new-price * discount-percent) 102400 )
          ;; find the new price
          ifelse (medianPriceOfHousesForSale * (max-price-RTB / 100)) >= discount-price
          [set new-price min ( (list (new-price - discount-price) ( (medianPriceOfHousesForSale * (max-price-RTB / 100)) - discount-price) ) )]
          [set new-price new-price - discount-price]
        ]
      ] ;; assign the median price of all record houses to new-price
      [
        let local-houses turtle-set filter [h -> [myType] of h = "mortgage"] plocality ;; if no local-sales exist, take neighboring houses around the current realtor under `local-houses`
        ifelse any? local-houses  ;; if local-houses exist
        [set new-price median [sale-price] of local-houses  ;; set the median price of all local-houses to be new-price
        ]
        [set new-price average-price ] ;; otherwise set average-price of the realtor to be new-price (is realtor's average-price updated every tick?)
        if ptype = "social" [
          ;; find the number of ticks beyond 5 years that through which the household occupied a social house
          let time-for-extra-discount max ( (list 0 (([time-in-social-house] of ([my-occupier] of property) / ticksPerYear) - 5)) )
          ;; find the total discount (35% plus 1% for every year spent in a social house beyond 5 years, at a maximum of 70% or £102,000)
          ;; reference https://www.gov.uk/right-to-buy-buying-your-council-home/discounts
          let discount-percent min ( (list 0.7 (0.35 + (0.1 * time-for-extra-discount))) )
          ;; maximum discount value must not exceed £102,400
          let discount-price min ( list (new-price * discount-percent) 102400 )
          ;; find the new price
          ifelse (medianPriceOfHousesForSale * (max-price-RTB / 100)) >= discount-price
          [set new-price min ( (list (new-price - discount-price) ( (medianPriceOfHousesForSale * (max-price-RTB / 100)) - discount-price) ) )]
          [set new-price new-price - discount-price]
        ]
      ]
    ]

    ; not owned
    if (ptype = "rent") or (ptype = "social" and [for-social?] of property = true) [
      ifelse any? turtle-set local-sales-rent  ;; if the local-sales exist
                                               ;; modified to new-rent and rent-price
      [
        set new-rent median [ renting-price ] of turtle-set local-sales-rent
        if ptype = "social" [set new-rent min ( list (average-rent * (social-to-private-rent / 100)) (new-rent * (social-to-private-rent / 100)) )]
      ] ;; assign the median price of all record houses to new-price
      [ let local-houses turtle-set filter [h -> [myType] of h = "rent"] plocality;; if no local-sales exist, take neighboring houses around the current realtor under `local-houses`
        ifelse any? local-houses  ;; if local-houses exist
        [set new-rent median [rent-price] of local-houses]  ;; set the median price of all local-houses to be new-price
        [set new-rent average-rent ] ;; otherwise set average-price of the realtor to be new-price (is realtor's average-price updated every tick?)
                                     ;; assure the new social housing rent is lower than its respective private rent market value
        if ptype = "social" [set new-rent min ( list (average-rent * (social-to-private-rent / 100)) (new-rent * (social-to-private-rent / 100)) )]
      ]
    ]
  ]


  ; if calculate-wealth? = false, find the locality houses and the records while evaluating
  [
    let local-sales-sold (turtle-set sales-sold) with [ the-house != nobody and ( [distance property ] of the-house ) < Locality and selling-price > 0]  ;; new-version
                                                                                                                                                         ;; under realtor context, sales is a list of records, use `turtle-set` force list into an agentset to use with, each record has property of the-house
                                                                                                                                                         ;; get all the sales (lists of records) whose houses are sold and those sold-houses are neighboring to the input house under `local-sales`
    let local-sales-rent (turtle-set sales-rent) with [ the-house != nobody and ( [distance property ] of the-house ) < Locality and renting-price > 0]  ;; new-version

    if (ptype = "mortgage") or (ptype = "social" and [for-rightToBuy?] of property = true) [ ; owned
      ifelse any? local-sales-sold  ;; if the local-sales exist
      [
        ;; assign the median price of all record houses to new-price
        set new-price median [ selling-price ] of local-sales-sold
        if ptype = "social" [
          ;; find the number of ticks beyond 5 years that through which the household occupied a social house
          let time-for-extra-discount max ( (list 0 (([time-in-social-house] of ([my-occupier] of property) / ticksPerYear) - 5)) )
          ;; find the total discount (35% plus 1% for every year spent in a social house beyond 5 years, at a maximum of 70% or £102,000)
          ;; reference https://www.gov.uk/right-to-buy-buying-your-council-home/discounts
          let discount-percent min ( (list 0.7 (0.35 + (0.1 * time-for-extra-discount))) )
          ;; maximum discount value must not exceed £102,400
          let discount-price min ( list (new-price * discount-percent) 102400 )
          ;; find the new price
          ifelse (medianPriceOfHousesForSale * (max-price-RTB / 100)) >= discount-price
          [set new-price min ( (list (new-price - discount-price) ( (medianPriceOfHousesForSale * (max-price-RTB / 100)) - discount-price) ) )]
          [set new-price new-price - discount-price]
        ]
      ]
      [ let local-houses houses with [ distance myself <= Locality and myType = "mortagage" ];; if no local-sales exist, take neighboring houses around the current realtor under `local-houses`
        ifelse any? local-houses  ;; if local-houses exist
        [set new-price median [sale-price] of local-houses  ;; set the median price of all local-houses to be new-price
        ]
        [set new-price average-price ] ;; otherwise set average-price of the realtor to be new-price (is realtor's average-price updated every tick?)
        if ptype = "social" [
          ;; find the number of ticks beyond 5 years that through which the household occupied a social house
          let time-for-extra-discount max ( (list 0 (([time-in-social-house] of ([my-occupier] of property) / ticksPerYear) - 5)) )
          ;; find the total discount (35% plus 1% for every year spent in a social house beyond 5 years, at a maximum of 70%)
          ;; reference https://www.gov.uk/right-to-buy-buying-your-council-home/discounts
          let discount-percent min ( (list 0.7 (0.35 + (0.1 * time-for-extra-discount))) )
          ;; maximum discount value must not exceed 102400
          let discount-price min ( list (new-price * discount-percent) 102400 )
          ;; find the new price
          ifelse (medianPriceOfHousesForSale * (max-price-RTB / 100)) >= discount-price
          [set new-price min ( (list (new-price - discount-price) ( (medianPriceOfHousesForSale * (max-price-RTB / 100)) - discount-price) ) )]
          [set new-price new-price - discount-price]
        ]
      ]
    ]

    ; not owned
    if (ptype = "rent") or (ptype = "social" and [for-social?] of property = true) [
      ifelse any? local-sales-rent  ;; if the local-sales exist
                                    ;; modified to new-rent and rent-price
      [
        set new-rent median [ renting-price ] of local-sales-rent
        if ptype = "social" [set new-rent min ( list (average-rent * (social-to-private-rent / 100)) (new-rent * (social-to-private-rent / 100)) )]

      ] ;; assign the median price of all record houses to new-price
      [ let local-houses houses with [ distance myself <= Locality and myType = "rent" ];; if no local-sales exist, take neighboring houses around the current realtor under `local-houses`
        ifelse any? local-houses  ;; if local-houses exist
        [set new-rent median [rent-price] of local-houses  ;; set the median price of all local-houses to be new-price
        ]
        [set new-rent average-rent ] ;; otherwise set average-price of the realtor to be new-price (is realtor's average-price updated every tick?)
                                     ;; assure the new social housing rent is lower than its respective private rent market value
        if ptype = "social" [set new-rent min ( list (average-rent * (social-to-private-rent / 100)) (new-rent * (social-to-private-rent / 100)) )]
      ]
    ]
  ]

  let ratio 0
  let threshold 2 ;; a base line for ratio
  if pType = "mortgage" or (ptype = "social" and [for-rightToBuy?] of property = true) [
    if old-price < 5000 [ report multiplier * new-price ]  ;; if current sale-price is too low, just accept multiplier * new-price  as valuation price
    set ratio new-price / old-price
    ifelse ratio > threshold  ;;
    [ set new-price threshold * old-price ] ;; if new-price is more than twice old-price,  make new-price twice of old-price. "
    [ if ratio < 1 / threshold [  set new-price old-price / threshold ] ]  ;;  if new-price is less than half of old-price, make new-price half of old-price.
                                                                           ;; for social houses, assure the price is lower than median after applying the multiplier
    if ptype = "social" [
      set new-price min ( list (multiplier * new-price) (medianPriceOfHousesForSale * (max-price-RTB / 100)) )
      report new-price
    ]
    ;; for mortgage houses, report with the multiplier
    report  multiplier * new-price  ;; finally report multiplier * new-price" "."
  ]
  if (pType = "rent") or (ptype = "social" and [for-social?] of property = true)  [
    if old-rent < (2000 / ticksPerYear) [ report multiplier * new-rent ]  ;; if current sale-price is too low, just accept multiplier * new-price  as valuation price
    set ratio new-rent / old-rent
    ifelse ratio > threshold  ;;
    [ set new-rent threshold * old-rent ] ;; if new-rent is more than twice old-rent,  make new-rent twice of old-rent. "
    [
      if ratio < 1 / threshold [ set new-rent old-rent / threshold ]
    ]  ;;  if new-rent is less than half of old-rent, make new-rent half of old-rent.
    if ptype = "rent" [
;      type property type " offered to " type [offered-to] of property type " valuated rent for " type multiplier * new-rent type "\n"
      report  multiplier * new-rent]  ;; finally report multiplier * new-rent" "."
    if ptype = "social" [report  min ( list (multiplier * new-rent) (multiplier * average-rent) ((max-rent-social / 100) * average-rent) ) ]  ;; Assure the social housing value does not significantly increase above the average rent in the realtor's territory
  ]

end

to make-offers [buyers houses-for-sale houses-for-rent houses-for-social]
  ;; make an offer ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Owners make an offer based on the market type they are in
  ; start with "mortgage" | these "owners" want to buy a house to reside in
  ask buyers with [ on-market? = true and on-market-type = ["right-to-buy"] ] [
    make-offer-rightToBuy
  ]
  ask buyers with [ on-market? = true and on-market-type = ["mortgage"] ] [
    make-offer-mortgage houses-for-sale
  ]
  ; second, address "buy-to-let" | these buyers already have a house and they are well-off enough to buy another one
  ask buyers with [ on-market? = true and on-market-type = ["buy-to-let"] ] [
    make-offer-mortgage houses-for-sale
  ]
  ; third, address "rent" | these buyers do not own a house and want to become a tenant
  ask buyers with [ on-market? = true and (member? "rent" on-market-type) ] [
    make-offer-rent houses-for-rent
  ]
  ask buyers with [ on-market? = true and on-waiting-list? = false and (member? "social" on-market-type)] [
    ;; make-offer-social (i.e., join a waiting list)
    make-offer-social
  ]
  set nOwnersOffered count owners with [is-house? made-offer-on ]

end

to make-offer-mortgage [ houses-for-sale ]
  ;; increment the time on market counter by 1 (applied for all market types)
  set time-on-market time-on-market + 1

  if on-market-type = ["mortgage"] [
    ;; use current income, Affordability, interestPerTick to calc new-mortgage
    let new-repayment (income * Affordability / (ticksPerYear * 100))
    let new-mortgage 0
    let mortgage-budget 0
    let mortgage-income 0
    ;; new mortgage of first time buyers
    ifelse first-time? = true
    [
      ;; calculate the mortgage based on the (1) income restrictions; and (2) LTI restrictions
      set mortgage-budget (1 - ( 1 + interestPerTickFT ) ^ ( - MortgageDurationFirstTime * TicksPerYear )) * new-repayment / interestPerTickFT
      set mortgage-income MaxLoanToIncomeFT * income
    ]
    ;; new mortgage of normal buyers
    [
      ;; calculate the mortgage based on the (1) income restrictions; and (2) LTI restrictions
      set mortgage-budget (1 - ( 1 + interestPerTick ) ^ ( - MortgageDuration * TicksPerYear )) * new-repayment / interestPerTick
      set mortgage-income MaxLoanToIncome * income
    ]
    ;; Select the lower value based on the previously mentioned restrictions
    set new-mortgage min (list mortgage-budget mortgage-income)

    ;; use current income, Affordability, interestPerTick to calc new-mortgage
    ;let new-mortgage income * Affordability / ( interestPerTick * ticksPerYear * 100 )
    ;; actual budget for buying a house == new-mortgage - duty or tax we get back
    let budget new-mortgage - stamp-duty-land-tax new-mortgage "mortgage"
    ;; buyer use capital and capital-parent to pay for new deposit
    let deposit capital + capital-parent
    ;; block the child from using the parent's capital if the parent is already on the market (otherwise we will be double counting the parent's capital in the offers)
    if is-owner? parent [
      if [on-market?] of parent = true [set deposit capital]
    ]
    ;; under the context of owners, if it owns a house, update new deposit with new deposit + sale-price of current house - current mortgage of my-house
    ;if is-house? my-house [
    if length my-ownership > 0 [
      let index-temp position my-house my-ownership
      if [for-sale?] of my-house = true [set deposit deposit + ([ sale-price ] of my-house - item index-temp mortgage) ]
    ]
    ;; upperbound = the maximum amount afford to offer on a house = new mortgage - duty-back + new deposit
    let upperbound budget + deposit
    ;; if mortgage is less than house value => (MaxLoanToValue/100 < 100/100 ) ;; update upperbound with the less between two similar values
    if first-time? = False and MaxLoanToValue < 100 [set upperbound min ( list (budget + deposit) (deposit / ( 1 - MaxLoanToValue / 100 )) ) ]
    if first-time? = True and MaxLoanToValueFirstTime < 100 [set upperbound min ( list (budget + deposit) (deposit / ( 1 - MaxLoanToValueFirstTime / 100 )) )]

    ;; if I cannot purchase, but I have a house, get out of the market for this round and assure any offers made to my house are removed
    if upperbound < 0 and is-house? my-house[
      set on-market? false
      set on-market-type (list)
      ask my-house [
        set for-sale? false
        set for-rent? false
        ;; if someone made an offer on the my-house, make sure they revert their offer
        if is-owner? offered-to [
          ask offered-to [
            set made-offer-on nobody
            set expected-move-date nobody
          ]
        ]
        set offered-to nobody
        set rented-to nobody
      ]
      stop
    ]
    ;; if I cannot purchase and I do not have a house, stay on the market (i.e., do nothing)
    if upperbound < 0 and not is-house? my-house [stop]

    ;; set lowerbound to be 70% of upperbound
    let lowerbound upperbound * 0.7
    ;; get the current owner's my-house under `current-house`
    let current-house my-house
    let current-ownership turtle-set my-ownership
    ;; from all the houses on sale, get those
    ;; without offer
    ;; and sale-prices within upperbound
    ;; and sale-prices greater than lowerbound
    ;; and the house is not current house, assinged  into `interesting-houses`
    let interesting-houses houses-for-sale with [
      not is-owner? offered-to and
      sale-price <= upperbound and
      sale-price > lowerbound and
      self != current-house ]
    ;; assure buyers on mortgage market do not make offers on their own houses
    if any? current-ownership [ask current-ownership [set interesting-houses other interesting-houses]]
    ;; if number of interesting-houses > BuyerSearchLength (number of houses buyers willing to see)
    ;; then select randomly BuyerSearchLength number of interesting-houses
    if count interesting-houses > BuyerSearchLength [set interesting-houses n-of BuyerSearchLength interesting-houses with [sale-price < (budget + deposit)]]
    ;; if interesting-houses exist
    if any? interesting-houses [
      ;; find the house with the maximum sale-price of interesting-houses and assigned to `property` a local-var
      let property max-one-of interesting-houses [ sale-price ]
      ;; if the `property` is a house
      if is-house? property [
        ;; assign the current owner as `offered-to` under the context of `property`
        ;; set `ticks` to be `offer-date` (house property)
        ask property [
          set offered-to myself
          set offer-date ticks
        ]
        ;; assign `property` (a house ) to owner's property `made-offer-on`
        set made-offer-on property
        ;; assign the property transaction time properly
        set expected-move-date ticks + ((mortgage-lag / 12) * ticksPerYear)
      ]
    ]
  ]

  if on-market-type = ["buy-to-let"] [
    ;; use current income, Affordability, interestPerTick to calc new-mortgage
    let new-repayment (income * Affordability / (ticksPerYear * 100))
    let new-mortgage (1 - ( 1 + interestPerTickBTL ) ^ ( - MortgageDurationBTL * TicksPerYear )) * new-repayment / interestPerTickBTL
    ;let new-mortgage income * Affordability / ( interestPerTick * ticksPerYear * 100 )
    ;; actual budget for buying a house == new-mortgage - duty or tax we get back
    let budget new-mortgage - stamp-duty-land-tax new-mortgage "buy-to-let"
    ;; buyer use capital to pay for new deposit
    let deposit capital
    ;; upperbound = the maximum amount afford to offer on a house = new mortgage - duty-back + new deposit
    let upperbound budget + deposit
    ;; if mortgage is less than house value => (MaxLoanToValue/100 < 100/100 ) ;; update upperbound with the less between two similar values
    if MaxLoanToValueBTL < 100 [set upperbound min ( list (budget + deposit ) ( deposit / ( 1 - MaxLoanToValueBTL / 100 ))) ]
    ;; under the context of owners, if it has a house, update new deposit with new deposit + sale-price of current house - current mortgage
    if upperbound < 0 [
      set on-market? false
      set on-market-type (list)
      stop
    ]
    ;; set lowerbound to be 70% of upperbound
    let lowerbound upperbound * 0.7
    ;; get the current owner's my-house under `current-house`
    let current-house my-house
    ;; get the current owner's my-ownership under 'current-ownership'
    let current-ownership nobody
    ifelse my-house != "external"
    [ set current-ownership turtle-set my-ownership ]
    [
      let my-ownership-temp remove-duplicates my-ownership
      set current-ownership turtle-set remove-item 0 my-ownership-temp
    ]
    ;; from all the houses on sale, get those
    ;; without offer
    ;; and sale-prices within upperbound
    ;; and sale-prices greater than lowerbound
    ;; and the house is not current house, assinged  into `interesting-houses`
    let interesting-houses houses-for-sale with [
      not is-owner? offered-to and
      sale-price <= upperbound and
      sale-price > lowerbound and
      self != current-house ]
    ;; assure buyers on buy-to let market do not make offers on their own houses
    if any? current-ownership [ask current-ownership [set interesting-houses other interesting-houses]]
    ;; if number of interesting-houses > BuyerSearchLength (number of houses buyers willing to see)
    ;; then select randomly BuyerSearchLength number of interesting-houses
    if count interesting-houses > BuyerSearchLength [set interesting-houses n-of BuyerSearchLength interesting-houses with [sale-price < (budget + deposit)]]
    ;; if interesting-houses exist
    if any? interesting-houses [
      ;; find the house with the maximum sale-price of interesting-houses and assigned to `property` a local-var
      let property max-one-of interesting-houses [ sale-price ]
      ;; if the `property` is a house
      if is-house? property [
        ;; assign the current owner as `offered-to` under the context of `property`
        ;; set `ticks` to be `offer-date` (house property)
        ask property [
          set offered-to myself
          set offer-date ticks
        ]
        ;; assign `property` (a house ) to owner's property `made-offer-on`
        set made-offer-on property
        ;; assign the property transaction time properly
        set expected-move-date ticks + ((mortgage-lag / 12) * ticksPerYear)
      ]
    ]
  ]

end

to make-offer-rightToBuy
  ;; assign the household's record of the house it made offer on and the expected move date
  set made-offer-on my-house
  set expected-move-date ticks + ((RTB-lag / 12) * ticksPerYear)
  ;; update the house's record of who made an offer and when they made it
  ask my-house [
    set offered-to myself
    set offer-date ticks
  ]
end

to make-offer-rent [ houses-for-rent ]
  ;; increment the time on market counter by 1 (applied for all market types)
  set time-on-market time-on-market + 1

  let new-rent income * Affordability-rent / ( ticksPerYear * 100 );; use current income, Affordability, interestPerTick to calc new-mortgage
  let budget new-rent
  let upperbound budget                                                    ;; upperbound = the maximum amount afford to offer on a house = new mortgage - duty-back + new deposit

  let lowerbound upperbound * 0.7                                                   ;; set lowerbound to be 70% of upperbound
  let current-house my-house                                                        ;; get the current owner's my-house under `current-house`
  let interesting-houses houses-for-rent with [                                     ;; from all the houses on sale, get those
                            not is-owner? offered-to and                            ;; without offer
                            rent-price <= upperbound and                            ;; and sale-prices within upperbound
                            rent-price > lowerbound and                             ;; and sale-prices greater than lowerbound
                            self != current-house ]                                 ;; and the house is not current house,            assinged  into `interesting-houses`


  if count interesting-houses > BuyerSearchLength [                                 ;; if number of interesting-houses > BuyerSearchLength (number of houses buyers willing to see)
    set interesting-houses n-of BuyerSearchLength interesting-houses                ;; then select randomly BuyerSearchLength number of interesting-houses
    ]

  if any? interesting-houses [                                                      ;; if interesting-houses exist
    let property max-one-of interesting-houses [ rent-price ]                       ;; find the house with the maximum sale-price of interesting-houses and assigned to `property` a local-var
      if is-house? property [                                                       ;; if the `property` is a house
      ask property [                                                                ;; ask this house
        set offered-to myself                                                     ;; assign the current owner as `offered-to` under the context of `property`
        set offer-date ticks                                                      ;; set `ticks` to be `offer-date` (house property)
      ]
      ;; assign `property` (a house ) to owner's property `made-offer-on` and assing `expected-move-date`
      set made-offer-on property
      set expected-move-date ticks + ((rent-lag / 12) * ticksPerYear)
    ]
  ]
end

to make-offer-social
  set on-waiting-list? true
  ask one-of public-sectors [set waiting-list lput myself waiting-list]
  ;; remove from the market (the households are identified later through the `on-waiting-list` indicator)
  if on-market-type = ["social"] [set on-market? false]
end


to-report stamp-duty-land-tax [ cost market ]
  ;; These values are prior 2023 and are no longer applied in the model
  ;; stamp duty land tax ('stamp duty') is 1% for sales over $150K, 3% over $250K, 4% over $500K,  (see http://www.hmrc.gov.uk/so/rates/index.htm )
;  if StampDuty? [
;
;    if cost > 500000 and  [ report 0.04 * cost ]
;
;    if cost > 250000 and  [ report 0.02 * cost ]
;
;    if cost > 150000 [ report 0.01 * cost ]
;    ]

  ;; Calculate stamp duty
  ;; (see https://www.gov.uk/stamp-duty-land-tax/residential-property-rates)
  if StampDuty? [
    ;; Stamp duty is is 5% on the sale price between £250k and £925k, 10% between £925k and £1.5m and 12% above £1.5m
    if StampDuty-Rates = "Up to 31 March 2025"[
      let base 0
      if market = "buy-to-let" [set base (cost * 0.03)]
      if cost <= 250000 [ report base + 0 ]
      if cost > 250000 and cost <= 925000 and StampDuty-B? = true [report base + ((cost - 250000) * 0.05)]
      if cost > 925000 and cost <= 1500000 and StampDuty-C? = true [report base + (( 675000 * 0.05 ) + ( (cost - 925000) * 0.1 ))]
      if cost > 1500000 and StampDuty-D? = true [report base + ((675000 * 0.05) + (575000 * 0.1) + ( (cost - 1500000) * 0.12))]
    ]
    ;; Stamp duty is is 2% on the sale price between £125k and £250k, 5% between £250k and £925k, 10% between £925k and £1.5m and 12% above £1.5m
    if StampDuty-Rates = "From 1 April 2025"[
      let base 0
      if market = "buy-to-let" [set base (cost * 0.05)]
      if cost <= 125000 [ report base + 0 ]
      if cost > 125000 and cost <= 250000 and StampDuty-A? = true [ report base + ((cost - 125000) * 0.02) ]
      if cost > 250000 and cost <= 925000 and StampDuty-B? = true [report base + (( 125000 * 0.02 ) + (cost - 250000) * 0.05)]
      if cost > 925000 and cost <= 1500000 and StampDuty-C? = true [report base + (( 125000 * 0.02 ) + ( 675000 * 0.05 ) + ( (cost - 925000) * 0.1 ))]
      if cost > 1500000 and StampDuty-D? = true [report base + (( 125000 * 0.02 ) + (675000 * 0.05) + (575000 * 0.1) + ( (cost - 1500000) * 0.12))]
    ]
  ]

  report 0
end

;; function can now be called anywhere (not owner specific)
to-report follow-chain [buyer-tenant first-link]

  ;; If the buyer-tenant did not make any offer or is not on the market in the first place, report a false chain
  if [on-market-type] of buyer-tenant = ["right-to-buy"] [report true]
  if not is-house? [made-offer-on] of buyer-tenant [report false]
  if [on-market?] of buyer-tenant = false [report false]
  ;; If the buyer is on the mortgage market
  if [on-market-type] of buyer-tenant = ["mortgage"] or [on-market-type] of buyer-tenant = ["buy-to-let"] [
    let buyer buyer-tenant
    let seller [my-owner] of made-offer-on
    ;; If there is no seller (i.e., house not owned), report a true chain
    if not is-owner? seller [report true]
    ;; If the seller has more than one house (i.e., seller does not need to find another house to buy before the transaction), report a true chain
    if count turtle-set [my-ownership] of seller > 1 [report true]
    ;; Safegaurd in case the buyer is buying from itself (this should not happen except unless there is a bug)
    if buyer = seller [report true]
    if seller = first-link [report true]
    ;; Else, meaning, if the seller has one house
    ;;;; Check if there is a delay in the expected-move-date, report the new expected-move-date
    if [expected-move-date] of seller != nobody and [expected-move-date] of seller > [expected-move-date] of buyer [report [expected-move-date] of seller]
    ;;;; If no delays, check if the seller has a confirmed house to buy before making the transaction
    report follow-chain seller first-link
  ]

  ;; If the tenant is on the rent market
  if member? "rent" [on-market-type] of buyer-tenant [
    let tenant buyer-tenant
    let house-made-offer-on [made-offer-on] of tenant
    let old-occupier [my-occupier] of house-made-offer-on
    let landlord [my-owner] of house-made-offer-on
    ;; If there is no occupier (i.e., the house is vacant and can be directly rented), report true chain
    if not is-owner? old-occupier [report true]
    if first-link = old-occupier [report true]
    ;; Else, meaning, if there is an occupier, check if that occupier found anouther house to rent or not before making the transaction
    ;;;; Check if there is a delay in the expected-move-date, report the new expected-move-date
    if [expected-move-date] of old-occupier != nobody and [expected-move-date] of old-occupier > [expected-move-date] of tenant [report [expected-move-date] of old-occupier]
    ;;;; If no delays, check if the old-occupier has a confirmed house to buy before making the transaction
    report follow-chain old-occupier first-link
  ]
end



to move-house [buyer-tenant]
  let new-house [made-offer-on] of buyer-tenant
  if not (is-house? new-house) [stop]

  ;; Mortgage or BTL
  if on-market-type = ["mortgage"] or on-market-type = ["buy-to-let"] [
    ;; define buyer and seller
    let buyer buyer-tenant
    let seller [my-owner] of new-house
    ;; address the surplus of the seller if they exist
    if is-owner? seller or is-administrator? seller [manage-surplus-seller seller new-house]
    ;; address the surplus of the buyer (includes managing capital, mortgage and repayments
    ;; manage the budget/capital of buyer
    manage-surplus-buyer buyer
    ;; manage the ownership parameters of the buyer
    manage-ownership-buyer buyer
    ;; if there is a seller, manage their ownership parameters
    if is-owner? seller or is-administrator? seller [
      manage-ownership-seller seller new-house
    ]
  ]

  ;; Social
  if is-house? made-offer-on and [myType] of made-offer-on = "social" and on-market-type != ["right-to-buy"] [
    ;; define the tenant and the landlord (public sector)
    let social-tenant buyer-tenant
    let public-landlord [my-owner] of new-house
    ;; manage the budget/income of tenant
    manage-surplus-social-tenant social-tenant
    ;; manage the ownership of tenant
    manage-ownership-social-tenant social-tenant
    ;; manage the ownership of landlord
    manage-ownership-public-landlord public-landlord new-house
  ]

  ;; Private rent
  if is-house? made-offer-on and [myType] of made-offer-on = "rent" [
    ;; define tenant and landlord
    let tenant buyer-tenant
    let landlord [my-owner] of new-house
    ;; manage the budget/income of the landlord
    manage-surplus-landlord landlord new-house
    ;; manage the budget of the tenant
    manage-surplus-tenant tenant
    ;; manage the ownership parameters of the tenant
    manage-ownership-tenant tenant
  ]

  ;; RTB
  if on-market-type = ["right-to-buy"] [
    ;; define buyer (current tenant) and public-seller
    let social-buyer buyer-tenant
    let public-seller [my-owner] of new-house
    ;; manage the budget of the buyer
    manage-surplus-social-buyer social-buyer
    ;; manage the ownership of the buyer
    manage-ownership-social-buyer social-buyer
    ;; manage the ownership of the public-sector agent
    manage-ownership-public-seller public-seller new-house
  ]

end

;; manage ownership of the social tenant
to manage-ownership-social-tenant [tenant]
  let new-house [made-offer-on] of tenant
  let house-temp my-house
  let myType-temp myType
  ask tenant [
    ;; manage the parameters of the renter
    show-turtle
    move-to new-house
    set homeless 0
    set myType "social"
    set my-house new-house
    set my-rent [ rent-price ] of new-house
    set my-ownership (list)
    set made-offer-on nobody
    set expected-move-date nobody
    set on-market? false
    set on-market-type (list)
    set on-waiting-list? false
    ; manage the parameters of the new-house
    ask new-house [
      ;; make sure the occupier unregisters the house from their my-house parameter
      ;; the occupier will later rent another house (this is checked within the follow-chain function)
      if is-owner? my-occupier [ask my-occupier [set my-house nobody]]
      set my-occupier myself
      set rented-to myself
      set for-sale? false
      set for-rent? false
      set for-social? false
      set for-rightToBuy? false
    ]
    ; manage the parameters of the old house
    if is-house? house-temp [
      ask house-temp [
        set my-occupier nobody
        set rented-to nobody
        set for-sale? false
        set for-rightToBuy? false
        ifelse myType = "social" [set for-social? true] [set for-social? false]
        ifelse myType = "rent" [set for-rent? true] [set for-rent? false]
      ]
    ]
  ]

end

;; manage the ownership of the private renting tenant
to manage-ownership-tenant [tenant]
  let new-house [made-offer-on] of tenant
  let house-temp my-house
  ask tenant [
    ;; if seller is an owner, calc the rent and assign.
    ;; record the rent transaction
    hatch-records 1 [
      hide-turtle
      move-to new-house
      set date ticks
      set date ticks
      set the-house new-house
      set selling-price 0
      set renting-price [rent-price] of new-house
      ;ask [ my-realtor ] of new-house [ file-record myself ]
      file-record ([my-realtor] of new-house) (self)
    ]
    ;; manage the parameters of the tenant
    show-turtle
    move-to new-house
    set homeless 0
    set time-on-market 0
    set on-cooldown? false
    set time-on-cooldown 0
    set myType "rent"
    set my-house new-house
    set my-rent [ rent-price ] of new-house
    set my-ownership (list)
    set made-offer-on nobody
    set expected-move-date nobody
    set on-market? false
    set on-market-type remove "rent" on-market-type
    ; manage the parameters of the new-house
    ask new-house [
      ;; make sure the occupier unregisters the house from their my-house parameter
      ;; the occupier will later rent another house (this is checked within the follow-chain function)
      if is-owner? my-occupier [ask my-occupier [set my-house nobody]]
      set my-occupier myself
      set rented-to myself
      set for-sale? false
      set for-rent? false
    ]
    ; manage the parameters of the old house
    if is-house? house-temp [
      ask house-temp [
        set my-occupier nobody
        set rented-to nobody
        set for-sale? false
        set for-rent? true
      ]
    ]
  ]
end

;; manage the ownership of the buyer
to manage-ownership-buyer [buyer]
  let new-house [made-offer-on] of buyer
  ask buyer [
    let house-temp my-house
    if on-market-type = ["mortgage"] [
      ;; record the sale transaction
      hatch-records 1 [
        hide-turtle
        move-to new-house
        set date ticks
        set the-house new-house
        set selling-price [sale-price] of new-house
        set renting-price [rent-price] of new-house
        file-record ([my-realtor] of new-house) self
      ]

      ;; manage the situation when a renter is buying and moving from their current my-house
      if is-house? my-house [
        if [myType] of my-house = "rent" or [myType] of my-house = "social" [
          ask my-house [
            set my-occupier nobody
            set rented-to nobody
            put-on-market
          ]
        ]
      ]

      ;; move to the new house
      show-turtle
      move-to new-house
      set homeless 0
      set time-on-market 0
      set on-cooldown? false
      set time-on-cooldown 0
      set myType "mortgage"
      set my-house new-house
      set date-of-acquire ticks
      ;; address the parameters of the new house, and take it off the market
      ask new-house [
        set myType "mortgage"
        set my-owner myself
        set my-occupier myself
        set rented-to nobody
        set offered-to nobody
        set for-sale? false
        set for-rent? false
        set for-social? false
        set for-rightToBuy? false
        colour-house
      ]

      ;; manage the parameters of the buyer
      set my-ownership (list new-house)
      set made-offer-on nobody
      set expected-move-date nobody
      set on-market? false
      set on-market-type (list)
      set first-time? false
    ]


    if on-market-type = ["buy-to-let"] [
      ;; record the transaction
      hatch-records 1 [
        hide-turtle
        move-to new-house
        set date ticks
        set the-house new-house
        set selling-price [sale-price] of new-house
        set renting-price [rent-price] of new-house
        file-record ([my-realtor] of new-house) self
      ]
      ;; manage the parameters of the new house, and put it on the rent market (the buy-to-let buyers must directly put their new purchase on the "rent" market)
      ask new-house [
        set myType "rent"
        set my-owner myself
        set my-occupier nobody
        set rented-to nobody
        set offered-to nobody
        put-on-market
        colour-house
      ]
      ;; manage the parameters of the buyer
      set time-on-market 0
      set on-cooldown? false
      set time-on-cooldown 0
      set my-ownership (lput new-house my-ownership)
      set made-offer-on nobody
      set expected-move-date nobody
      set on-market? false
      set on-market-type (list)
      set first-time? false
    ]
  ]

end

;; manage the ownership of the seller (mortgage market)
to manage-ownership-seller [seller seller-house]
  ask seller [
    set my-ownership remove seller-house my-ownership
  ]
end

;; manage the ownership of the social buyer (RTB)
to manage-ownership-social-buyer [buyer]
  let new-house [made-offer-on] of buyer
  ask buyer [
    let house-temp my-house
    ;; record the sale transaction
    hatch-records 1 [
      hide-turtle
      move-to new-house
      set date ticks
      set the-house new-house
      set selling-price [sale-price] of new-house
      set renting-price [rent-price] of new-house
      ;ask [ my-realtor ] of new-house [ file-record myself ]
      file-record ([my-realtor] of new-house) self
    ]

    ;; move to the new house
    show-turtle
    move-to new-house
    set homeless 0
    set myType "mortgage"
    set my-house new-house
    set date-of-acquire ticks
    ;; address the parameters of the new house, and take it off the market
    ask new-house [
      set myType "mortgage"
      set my-owner myself
      set my-occupier myself
      set rented-to nobody
      set offered-to nobody
      set for-sale? false
      set for-rent? false
      set for-social? false
      set for-rightToBuy? false
      colour-house
    ]

    ;; manage the parameters of the buyer
    set my-ownership (list new-house)
    set made-offer-on nobody
    set expected-move-date nobody
    set on-market? false
    set on-market-type (list)
    set first-time? false
  ]
end

;; manage ownership of public landlord (social housing)
to manage-ownership-public-landlord [landlord landlord-house]
  let tenant [my-occupier] of landlord-house
  ask landlord [
    set vacant-houses remove landlord-house vacant-houses
    set waiting-list remove tenant waiting-list
  ]
end

;; manage ownership of public seller (RTB)
to manage-ownership-public-seller [seller seller-house]
  ask seller [
    set my-ownership remove seller-house my-ownership
  ]
end

;; manages the surplus from a trade for the seller of an input house
to manage-surplus-seller [seller seller-house]
  let new-house seller-house
  ;; manage the selelr if it is an owner
  if is-owner? seller [
    ask seller [
      ;; find the index of the seller-house
      let index-temp position seller-house my-ownership
      ;; find the mortgage of the seller-house
      let mortgage-temp item index-temp mortgage
      ;; calculate the monetary surplus from selling the house (surplus should always be above or equal 0)
      let surplus [sale-price] of seller-house - mortgage-temp
      set capital capital + surplus
      set mortgage remove-item index-temp mortgage
      set mortgage-initial remove-item index-temp mortgage-initial
      set mortgage-type remove-item index-temp mortgage-type
      set repayment remove-item index-temp repayment
      set income-rent remove-item index-temp income-rent
      set surplus-rent remove-item index-temp surplus-rent
      set rate remove-item index-temp rate
      set rate-duration remove-item index-temp rate-duration
      set mortgage-duration remove-item index-temp mortgage-duration
    ]
  ]
  ;; manage the seller if it is a legal administrator
  if is-administrator? seller [
    ask seller [
      ;; find the index of the seller-house
      let index-temp position seller-house my-ownership
      ;; find the mortgage of the seller-house
      let mortgage-temp item index-temp mortgage
      ;; identify inheritance tax
      let tax 0
      if inheritance-tax? = True [ set tax (inheritance-tax seller-house) ]
      ;; calculate the monetary surplus from selling the house (surplus should always be above or equal 0)
      let surplus [sale-price] of seller-house - mortgage-temp - tax
      let n-children length children
      ;; transfer the capital as an inheritance to the children
      ask turtle-set children [
        set capital capital + (surplus / n-children)
      ]
      set mortgage remove-item index-temp mortgage
    ]
  ]

end

;; owner function, manages capital, mortgage and repayment
to manage-surplus-buyer [buyer]
  let new-house [made-offer-on] of buyer
  ;; deduct the costs from the buyer (we are certain the owner has no my-ownership, else they will be on the buy-to-let market)
  let duty 0
  if on-market-type = ["mortgage"] [set duty stamp-duty-land-tax [sale-price] of new-house "mortgage"]
  if on-market-type = ["buy-to-let"] [set duty stamp-duty-land-tax [sale-price] of new-house "buy-to-let"]
  let price-and-duty [sale-price] of new-house + duty
  ask buyer [
    ; if capital is not enough to pay for the house
    ifelse [sale-price] of new-house > capital [
      ;; calc the highest mortgage a household can apply for and the highest repayment
      let mortgage-temp 0
      let MortgageDuration-temp 0
      let interestPerTick-temp 0
      if on-market-type = ["mortgage"] [
        ;; mortgage households depend on parents if available, this requires deducting from the capital of parents later
        set mortgage-temp (price-and-duty - capital - capital-parent)
        ;; manage [capital] of parent
        if is-owner? parent [
          ask parent [
            set capital capital - [capital-parent] of myself
          ]
        ]
        ;; define parameters to calculate repayment
        ifelse first-time? = true
        [
          set MortgageDuration-temp MortgageDurationFirstTime
          set interestPerTick-temp interestPerTickFT
          set mortgage-type lput ("first-time") mortgage-type
          set transactionsFirstTime lput ([sale-price] of new-house) transactionsFirstTime
        ]
        [
          set MortgageDuration-temp MortgageDuration
          set interestPerTick-temp interestPerTick
          set mortgage-type lput ("normal") mortgage-type
        ]
      ]
      if on-market-type = ["buy-to-let"] [
        ;; define parameters to calculate repayment
        set mortgage-temp (price-and-duty - capital)
        set MortgageDuration-temp MortgageDurationBTL
        set interestPerTick-temp interestPerTickBTL
        set mortgage-type lput ("buy-to-let") mortgage-type
      ]
      ;; assure capital is set to 0 after calculating the mortgage temp
      set capital 0
      ;; calc repayment to pay back mortgage
      let repayment-temp mortgage-temp * interestPerTick-temp / (1 - ( 1 + interestPerTick-temp ) ^ ( - MortgageDuration-temp * TicksPerYear ))

      ;; assign the repayment-temp and mortgage temp to their respective list for the owners
      set mortgage lput mortgage-temp mortgage
      set mortgage-initial lput mortgage-temp mortgage-initial
      set repayment lput repayment-temp repayment
      set income-rent lput 0 income-rent
      set surplus-rent lput (0 - repayment-temp) surplus-rent
      ;; assign the mortgage rate and rate duration
      set rate lput interestPerTick-temp rate
      ifelse length my-ownership = 0
      [set rate-duration lput ((MinRateDurationM + random (MaxRateDurationM - MinRateDurationM)) * ticksPerYear) (rate-duration)]
      [set rate-duration lput ((MinRateDurationBTL + random (MaxRateDurationBTL - MinRateDurationBTL)) * ticksPerYear) (rate-duration)]
      set mortgage-duration lput (MortgageDuration-temp * ticksPerYear) mortgage-duration
    ]
    ; or if the buyer is a cash buyer, capital pays all, mortgage, repayment both are 0, and remaining still kept in capital
    [
      ;; if the buyer is paying in cash, their mortgage and repayment do not change
      set capital capital - [sale-price] of new-house - duty
      if capital < 0 [set capital 0]
      set mortgage lput 0 mortgage
      set mortgage-initial lput 0 mortgage-initial
      set repayment lput 0 repayment
      set income-rent lput 0 income-rent
      set surplus-rent lput 0 surplus-rent
      set rate lput 0 rate
      ;; nobody in rate-duration is a dummy variable assuring that this mortgage is never checked
      set rate-duration lput nobody rate-duration
      set mortgage-duration lput nobody mortgage-duration
      ;; no mortgage type for cash buyers
      set mortgage-type lput nobody mortgage-type
    ]
  ]
end

;; manage the finances of the buyer (mortgage or BTL)
to manage-surplus-social-buyer [buyer]
  let new-house [made-offer-on] of buyer
  let price [sale-price] of new-house
  ask buyer [
    ; if capital is not enough to pay for the house
    ifelse [sale-price] of new-house > capital [
      ;; calc the highest mortgage a household can apply for and the highest repayment
      let mortgage-temp 0
      let MortgageDuration-temp 0
      let interestPerTick-temp 0
      ;; mortgage households depend on parents if available, this requires deducting from the capital of parents later
      set mortgage-temp (price - capital - capital-parent)
      ;; manage [capital] of parent
      if is-owner? parent [
        ask parent [
          set capital capital - [capital-parent] of myself
        ]
      ]
      ;; define parameters to calculate repayment
      set MortgageDuration-temp MortgageDurationRTB
      set interestPerTick-temp interestPerTickRTB
      set mortgage-type lput ("right-to-buy") mortgage-type
      set transactionsRightToBuy lput ([sale-price] of new-house) transactionsRightToBuy

      ;; assure capital is set to 0 after calculating the mortgage temp
      set capital 0
      ;; calc repayment to pay back mortgage
      let repayment-temp mortgage-temp * interestPerTick-temp / (1 - ( 1 + interestPerTick-temp ) ^ ( - MortgageDuration-temp * TicksPerYear ))

      ;; assign the repayment-temp and mortgage temp to their respective list for the owners
      set mortgage lput mortgage-temp mortgage
      set mortgage-initial lput mortgage-temp mortgage-initial
      set repayment lput repayment-temp repayment
      set income-rent lput 0 income-rent
      set surplus-rent lput 0 surplus-rent
      ;; assign the mortgage rate and rate duration
      set rate lput interestPerTick-temp rate
      set rate-duration lput ((MinRateDurationRTB + random (MaxRateDurationRTB - MinRateDurationRTB)) * ticksPerYear) (rate-duration)
      set mortgage-duration lput (MortgageDuration-temp * ticksPerYear) mortgage-duration
    ]
    ; or if the buyer is a cash buyer, capital pays all, mortgage, repayment both are 0, and remaining still kept in capital
    [
      ;; if the buyer is paying in cash, their mortgage and repayment do not change
      set capital capital - [sale-price] of new-house
      if capital < 0 [set capital 0]
      set mortgage lput 0 mortgage
      set mortgage-initial lput 0 mortgage-initial
      set repayment lput 0 repayment
      set income-rent lput 0 income-rent
      set surplus-rent lput 0 surplus-rent
      set rate lput 0 rate
      ;; nobody in rate-duration is a dummy variable assuring that this mortgage is never checked
      set rate-duration lput nobody rate-duration
      set mortgage-duration lput nobody mortgage-duration
      ;; no mortgage type for cash buyers
      set mortgage-type lput nobody mortgage-type
      set transactionsRightToBuy lput ([sale-price] of new-house) transactionsRightToBuy
    ]
  ]
end

;; manage the finances of the landlord (private rent)
to manage-surplus-landlord [landlord landlord-house]
  let rent-temp [rent-price] of landlord-house
  let index-temp position landlord-house [my-ownership] of landlord
  let repayment-temp item index-temp [repayment] of landlord
  ;; add the rent to the yearly income of the landlord
  ask landlord [
    set income-rent replace-item index-temp income-rent rent-temp
    set surplus-rent replace-item index-temp surplus-rent (rent-temp - repayment-temp)
  ]

end

;; manage the finance of the tenant (private rent)
to manage-surplus-tenant [tenant]
  ;; assign the rent parameter of the tenant
  let new-house [made-offer-on] of tenant
  ask tenant [
    set my-rent [ rent-price ] of new-house
  ]
;  type tenant type " moving to " type new-house type " | rent-price = " type [ rent-price ] of new-house type "\n"
end

;; manage the finances of the social tenant (social hosuing)
to manage-surplus-social-tenant [tenant]
  let new-house [made-offer-on] of tenant
  ask tenant [
    set my-rent [ rent-price ] of new-house
  ]
end

;; remove the outdated records from the realtors
to remove-outdates

  ;; remove old record ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; after certain period, all old records should be removed, realtors will remove all their sales
  ask records [ if date < (ticks - RealtorMemory) [ die ] ] ;; for each record, after RealtorMemory duration, it has to be removed
  ask realtors [ set sales-rent remove nobody sales-rent ] ;; ask realtors to remove dead records from the sales list
  ask realtors [ set sales-sold remove nobody sales-sold ] ;; ask realtors to remove dead records from the sales list

  ;; Note: the next part was removed as households are now allowed to keep their offers through ticks until they reach their `expected-move-date`

;  ; remove offers ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  ; remove the offer information upon a house
;  ask houses with [ is-owner? offered-to ] [  ;; for each of the houses which have owners/buyer to make offer on
;    ask offered-to [ set made-offer-on nobody ] ;; ask each buyer to set property `made-offer-on` as nobody
;    set offered-to nobody  ;; set the house's buyer property `offered-to` to be nobody
;    set offer-date 0  ;; set house property `offer-date` to 0
;    ;set for-sale? false
;    ;set for-rent? false
;  ]
end

;; demolish houses that reached their demolish age
to demolish-houses
   ;; demolish houses ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;demolish old houses or houses with below minimum price
   set nDemolished 0  ;; record the number of demolished houses at each tick

   if any? records [  ;; if there are records left

    let minimum-price-sold min-price-fraction * medianPriceOfHousesForSale ;; set minimum-price to be 10% of all mortgage houses median sale-price
    let minimum-price-rent min-price-fraction * medianPriceOfHousesForRent ;; set minimum-price to be 10% of all rent houses median rent-price
    let minimum-price-social min-price-fraction * medianPriceOfHousesForSocial ;; set minimum-price to be 10% of all social houses median rent-price
    let houses-rent houses with [myType = "rent"]
    let houses-sell houses with [myType = "mortgage"]
    let houses-social houses with [myType = "social"]

    ;; ask all houses, if its life is over its life limit or if the house is for sale and sale-price < minimum-price
    let houses-to-demolish (turtle-set
      houses-sell with [ (ticks > end-of-life) or  (for-sale? and sale-price <  minimum-price-sold )]
      houses-rent with [ (ticks > end-of-life) or  (for-rent? and rent-price <  minimum-price-rent )]
      houses-social with [ (ticks > end-of-life) or (for-rent? and rent-price < minimum-price-social)]
    )

    ask houses-to-demolish [
      ;ask realtors [ unfile-record myself ] ;; delete any record that mentions the house inside the sales of a realtor
      ask realtors [unfile-record self myself]
      ; remove the house from the locality of its surrounding houses
      if calculate-wealth? = true [ask turtle-set locality-houses [set locality-houses remove myself locality-houses]]
      ;; if the house is for mortgage and not on sale (i.e., the owner should be the occupier of the house)
      if myType = "mortgage" and for-sale? = false and for-rent? = false [
        ;; add the sale-price to the capital (this is applied as per the previous model without considering mortgage)
        ask my-owner [
          set capital capital + [sale-price] of myself
        ]
        ;; evict the current occupier
        let my-occupier-temp my-occupier
        evict my-occupier-temp
        if [on-waiting-list?] of my-occupier-temp = true [exit-social self]
        enter-market my-occupier-temp "mortgage"
        ;; demolish the house
        die
      ]
      ;; if the house is for mortgage and for sale (i.e., there are two options: (1) the owner put a rent house on the market as a type mortgage; (2) the owner put his/her own my-house on the market)
      if myType = "mortgage" and (for-sale? = true or for-rent? = true) [
        ; If the house is offered to an agent
        if is-owner? offered-to [
          ask offered-to [
            set made-offer-on nobody
            set expected-move-date nobody
          ]
        ]
        ; if the house has an owner and an occupier (these must always be the same unless there is a bug)
        if is-owner? my-owner and is-owner? my-occupier [
          ask my-owner [
            set capital capital + [sale-price] of myself
          ]

          let my-occupier-temp my-occupier
          evict my-occupier-temp
          if [on-waiting-list?] of my-occupier-temp = true [exit-social self]
          enter-market my-occupier-temp "mortgage"

          die

        ]
        ; if the house has an owner but there is nobody occupying it (can happen if it was for rent and is now put on the mortgage market due to a downshock or low income for the owner)
        if is-owner? my-owner and not is-owner? my-occupier [
          ;; remove the house from the owner's current my-ownership
          ask my-owner [
            ;; remove all the items associated to the demolished house from the owner's list
            let index-temp position myself my-ownership
            set my-ownership remove-item index-temp my-ownership
            set mortgage remove-item index-temp mortgage
            set mortgage-initial remove-item index-temp mortgage-initial
            set mortgage-type remove-item index-temp mortgage-type
            set repayment remove-item index-temp repayment
            set income-rent remove-item index-temp income-rent
            set surplus-rent remove-item index-temp surplus-rent
          ]

          die
        ]

        ;; demolish the house
        ;; this is a safety net for mortgage houses (should never be reached during the execution of the function)
        die
      ]

      if myType = "rent" [
        ;; manage ownership (landlord)
        if is-owner? my-occupier [
          ;; manage occupier (tenant)
          ;; evict the occupier
          let my-occupier-temp my-occupier
          evict my-occupier-temp
          ;; enter the rent market
          ;enter-market my-occupier-temp "rent"
          if not member? "mortgage" [on-market-type] of my-occupier-temp [enter-market my-occupier-temp "rent"]
        ]
        ;let my-owner-temp my-owner
        ask my-owner [
          ;; add the capital to the landlord of the house
          set capital capital + [sale-price] of myself
          ;; remove the house from the ownership of the landlord
          let index-temp position myself my-ownership
          set my-ownership remove-item index-temp my-ownership
          set mortgage remove-item index-temp mortgage
          set mortgage-initial remove-item index-temp mortgage-initial
          set mortgage-type remove-item index-temp mortgage-type
          set repayment remove-item index-temp repayment
          set income-rent remove-item index-temp income-rent
          set surplus-rent remove-item index-temp surplus-rent
        ]
        ;; make sure that any made offer for this house are cancelled
        if is-owner? offered-to [
          ask offered-to [
            set made-offer-on nobody
            set expected-move-date nobody
          ]
        ]
        ;; demolish house
        die
      ]

      if myType = "social" [
        ;; manage ownership (landlord)
        if is-owner? my-occupier [
          ;; manage occupier (tenant)
          ;; evict the occupier
          let my-occupier-temp my-occupier
          evict my-occupier-temp
          ;; enter the rent market
          if not member? "mortgage" [on-market-type] of my-occupier-temp [enter-market my-occupier-temp "social"]
        ]
        if is-owner? offered-to [
          ask offered-to [
            set made-offer-on nobody
            set expected-move-date nobody
          ]
        ]
        ;; manage the vacant-houses and ownership lists of the owner
        ask my-owner [
          if member? myself vacant-houses [set vacant-houses remove myself vacant-houses]
          set my-ownership remove myself my-ownership
        ]
        ;; demolish house
        die
      ]

      ;; safety net to assure demolishing happens (in case different types of houses are added to the model in the future)
      die
    ]
  ]
end

;; unfile all the records related to a house from the realtor
;; realtor procedure
to unfile-record [ input-realtors a-house ]          ;; realtor procedure
  ifelse calculate-wealth? = true [
    let A a-house
    let relevant-records records with [the-house = A]

    ask input-realtors [
      ; find all the records that must be unfiled (will be used for houses)
      let sales-to-remove filter [ s -> [the-house] of s = A ] sales-sold
      let rents-to-remove filter [ s -> [the-house] of s = A ] sales-rent

      ; delete any record that mentions the house
      if [myType] of A = "mortgage" [set sales-sold filter [ s -> [the-house] of s != A ] sales-sold]   ;; new-version]

      if [myType] of A = "rent" [set sales-rent filter [ s -> [the-house] of s != A ] sales-rent]   ;; new-version]

      ; loop through all the records sales that need to be removed
      ask turtle-set sales-to-remove [
        ; loop through all the houses that files the record sale in the current iteration
        ask turtle-set filed-at-houses [
          ; loop through all the local-sales list (each corresponding to one of the `local-realtors` of the house that filed the record in the current iteration)
          foreach local-sales [
            ; remove the record in the current iteration from the local-sales list in the current iteration
            records-list ->
            let index position records-list local-sales
            let filtered-at-index filter [a-record -> not member? a-record sales-to-remove] records-list
            set local-sales replace-item index local-sales filtered-at-index
          ]
        ]
      ]
      ;; loop through all the records rents that need to be removed
      ask turtle-set rents-to-remove [
        ; loop through all the houses that files the record rent in the current iteration
        ask turtle-set filed-at-houses [
          foreach local-rents [
            ; remove the record in the current iteration from the local-rents list in the current iteration
            records-list ->
            let index position records-list local-rents
            let filtered-at-index filter [a-record -> not member? a-record rents-to-remove] records-list
            set local-rents replace-item index local-rents filtered-at-index
          ]
        ]
      ]
    ]
  ]

  ; if calculate-wealth? = false
  [
    ask input-realtors [
      ; delete any record that mentions the house
      if [myType] of a-house = "mortgage" [set sales-sold filter [ s -> [the-house] of s != a-house ] sales-sold]   ;; new-version
      if [myType] of a-house = "rent" [set sales-rent filter [ s -> [the-house] of s != a-house ] sales-rent]   ;; new-version
    ]
  ]


end

;; decay the prices and rents of houses on the market with no offers each tick
to update-prices
  ;; reduce or update sale-prices of unsold houses ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; reduce sale-price is a house is not sold in each tick
  ask houses with [ for-sale? = true and mytype = "mortgage" and not is-owner? offered-to] [  ;; ask all houses which still are for sale
    set sale-price sale-price * (1 - PriceDropRate / (100 * ticksPerYear) );; to reduce its sale-price by certain amount
;    set rent-price rent-price * (1 - RentDropRate / (100 * ticksPerYear) )
    set on-market-period on-market-period + 1
  ]

  ask houses with [ for-rent? = true and mytype = "rent" and not is-owner? offered-to] [  ;; ask all houses which still are for sale
;    set sale-price sale-price * (1 - PriceDropRate / 100 )
    set rent-price rent-price * (1 - RentDropRate / 100 );; to reduce its sale-price by certain amount
  ]
end

;; update households' parameters every tick
to update-owners
  ;; update owners' mortgage and repayment in each tick  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; manage mortgages, repayments, income and capital of owners in the system
  ask owners with [length my-ownership > 1 and sum (mortgage) > 0] [
    let i 0
    foreach my-ownership [ house-temp ->
      ;let i position house-temp my-ownership
      let mortgage-temp item i mortgage
      let repayment-temp item i repayment
      let income-rent-temp item i income-rent

      ;; replace the mortgage at index i with the new mortgage after repayment
      ;set mortgage replace-item i mortgage ( mortgage-temp - (repayment-temp - (interestPerTick * mortgage-temp)) )
      set mortgage replace-item i mortgage ( mortgage-temp - repayment-temp )
      ;; if the owner paid the full mortgage of the house, set the mortgage and repayments back to zero
      if item i mortgage <= 0 [
        set mortgage replace-item i mortgage 0
        set repayment replace-item i repayment 0
      ]
      ;; calculate capital while adding income rent to the base income every tick
      set capital capital + ( (Savings / 100) * income-surplus )
      set i i + 1
    ]
  ]

  ;; myType condition was considered againist the value 1. Modified to "mortgage" to align with the new model.
  ask owners with [ is-house? my-house and myType = "mortgage" and sum (mortgage) > 0 and count turtle-set my-ownership = 1] [  ;; ask all owners who do have one house and mortgage to pay
    set mortgage replace-item 0 mortgage ( (item 0 mortgage) - (item 0 repayment) )  ;; mortgage will be reduced due to repayment
                                                                                                             ;; add income rent to the base income every tick
    set capital capital + ( (Savings / 100) * income-surplus )
    if item 0 mortgage <= 0 [  ;; if mortgage is fully repaid, then set both mortgage and repayment to 0
      set mortgage replace-item 0 mortgage 0
      set repayment replace-item 0 repayment 0
    ]
  ]

  ;; update tenants' capital in each tick
  ;; myType condition was considered againist the value 0, Modified to "rent" to align with the new model.
  ask owners with [ is-house? my-house and myType = "rent" ] [  ;; ask all owners who do have houses and mortgage to pay
    set capital capital + ( (SavingsRent / 100) * income-surplus )
    if capital < 0 [
      set capital 0
    ]
  ]

  ;; update the social tenants' capital in each tick
  ask owners with [is-house? my-house and myType = "social"] [
    set capital capital + ( (SavingsSocial / 100) * income-surplus )
    if capital < 0 [
      set capital 0
    ]
    set time-in-social-house time-in-social-house + 1
  ]

  ;; address the rate duration
  ask owners with [length my-ownership > 0] [
    let i 0
    let l length my-ownership
    while [i < l] [
      ;; if the rate duration reached 0,
      if item i rate-duration = 0 and item i repayment > 0 [
        let interestPerTick-temp 0
        if item i mortgage-type = "normal" [ set interestPerTick-temp interestPerTick ]
        if item i mortgage-type = "first-time" [ set interestPerTick-temp interestPerTickFT ]
        if item i mortgage-type = "buy-to-let" [ set interestPerTick-temp interestPerTickBTL ]
        if item i mortgage-type = "right-to-buy" [ set interestPerTick-temp interestPerTickRTB ]
        ;; if there is a change in the interest rate, recalculate the mortgage and the repayment
        if item i rate != interestPerTick-temp [
          ;; find old and new interest rates
          let old-interest (item i rate)
          let new-interest interestPerTick-temp
          ;; find total mortgage
          let total-mortgage item i mortgage-initial
          ;; calculate new repayment while assuring it is set to 0 if the mortgage duration ended (meaning all the repayments have been made)
          let old-repayment item i repayment
          let new-repayment 0
          if item i mortgage-duration > 0 [
            set new-repayment total-mortgage * interestPerTick-temp / (1 - ( 1 + interestPerTick-temp ) ^ ( - (item i mortgage-duration) * ticksPerYear ))
          ]
          set repayment replace-item i repayment new-repayment
        ]
        ;; update the owner's rate and rate-duration parameters
        set rate replace-item i rate interestPerTick-temp
        ; if this is the first house in my-ownership list (i.e., my-house)
        ifelse i = 0
        [set rate-duration replace-item i rate-duration ((MinRateDurationM + random (MaxRateDurationM - MinRateDurationM)) * ticksPerYear)]
        [set rate-duration replace-item i rate-duration ((MinRateDurationBTL + random (MaxRateDurationBTL - MinRateDurationBTL)) * ticksPerYear)]
      ]
      let duration-temp 0
      ;; subtract 1 tick from the rate duration
      if item i rate-duration != nobody [
        set duration-temp (item i rate-duration) - 1
        set rate-duration replace-item i rate-duration duration-temp
      ]
      if item i mortgage-duration != nobody [
        set duration-temp (item i mortgage-duration) - 1
        set mortgage-duration replace-item i mortgage-duration duration-temp
      ]
      ;; increment the index in the while loop
      set i i + 1
    ]
  ]

  ;; update the a residual set of parameters for all owners in the city (we exclude external houses)
  ask owners [
    update-surplus-income
    update-capital-parent
    update-cooldown
    update-not-well-off
    update-wealth
  ]
end

;; Remove administrators the have no ownership (they fulfilled their purpose and manage the
to update-administrators
  ask administrators [
    if length my-ownership = 0 [
      ask turtle-set children [set parent nobody]
      die
    ]
  ]
end

;; manage the aging process of households
to manage-age
  ask owners with [myType = "mortgage" or myType = "rent" or myType = "social"] [
    ; age 1 tick
    set age age + 1

    ; if age is the same as death-age give inheritance
    ; this transforms the agent to "administrator" if there are houses that need to be sold to distribute as capital to children
    if age >= death-age [
      if is-house? made-offer-on [
        ask made-offer-on [set offered-to nobody]
      ]
      give-inheritance self
      owners-die self
      stop
    ]



    ; if age is the same as birth-age + independent age (18 by default), generate a child agent
    let i 0
    while [i < length breed-age] [
      ;; record the presence of a child if breed age is reached (we do not generate an agent here to save memory)
      if age >= item i breed-age and length children <= i [
        ;set children lput ("placeholder") (children)
        set children lput (nobody) children
        set nBirthsThisTick nBirthsThisTick + 1
      ]
      ;; if the child reached the age of independence, create the owner agent
      if age = (item i breed-age) + (IndependenceAge * ticksPerYear) [
        hatch-owners 1 [
          ; address owner agent parameters
          set color black  ;; make owner red
          set size 0.7   ;; owner easy to see but not too big
          ;; ages
          set age [age] of myself - item i [breed-age] of myself
          set breed-age (list)
          set children (list)
          assign-breed-death-age self
          ;; parent
          set parent myself
          ;; assign income based on the type of parent (reset type to "independent" and capital to 0 after assign-income)
          set myType [myType] of parent
          assign-income
          set income-rent (list)
          set capital 0
          set capital-parent ([capital] of parent * (ParentToChildCapital / 100)) / (length [children] of parent)
          ;; firt-time buyer and propensity
          set first-time? true
          set on-market? false
          set on-market-type (list)
          set on-waiting-list? false
          set propensity random-float 1.0
          set propensity-social random-float 1.0
          set propensity-wait-for-RTB 1.0
          ;; houses, ownership and repayment
          set my-house nobody
          set my-ownership (list)
          set mortgage (list)
          set mortgage-initial (list)
          set mortgage-type (list)
          set mortgage-duration (list)
          set rate (list)
          set rate-duration (list)
          set repayment (list)
          set my-rent 0
          set homeless 0
          set made-offer-on nobody
          set expected-move-date nobody
          set date-of-acquire nobody
          ;; based on their financial conditions, these households will later join the rent market as they have no capital
          ;set on-market? true
          ;set on-market-type "rent"

          ;; manage the parent's children parameter
          ask parent [set children replace-item i children myself]
        ]

        set nIndependentThisTick nIndependentThisTick + 1
      ]
      ;; increment the while loop
      set i i + 1
    ]
  ]
end

;; give inheritance to the childre before dying (or create a managing administrator)
to give-inheritance [input-parent]

  ;; if the parent has children in the system
  if count turtle-set [children] of input-parent > 0 [
    ;; find the capital the owners are inheriting
    let parent-capital [capital] of input-parent
    let parent-children [children] of input-parent
    let parent-n-children length [children] of input-parent
    let parent-houses [my-ownership] of input-parent
    let parent-mortgage [mortgage] of input-parent

    ;; add the inheritance value to the capital parameters of the children
    ask turtle-set parent-children [ set capital capital + (parent-capital / parent-n-children)]

    ;; if the parent owns houses, put them on the market
    if length parent-houses > 0 [
      ;; evict households from the house and put the house on the market
      ask turtle-set parent-houses [
        if is-owner? my-occupier [
          evict my-occupier
          set myType "mortgage"
          put-on-market
        ]
      ]

      ;; create an administrator to manage the distribution of the cash from the houses when they are sold
      hatch-administrators 1 [
        set my-ownership parent-houses
        set mortgage parent-mortgage
        set children parent-children
        ask turtle-set parent-houses [set my-owner myself]
        ask turtle-set children [
          set parent myself
          set capital-parent 0
        ]
        hide-turtle
      ]
    ]

    ;; remove the houses from the parent's my-house and my-ownership parameters (to assure we do not re-evict them when we call the owners-die function)
    ask input-parent [
      set my-ownership (list)
      if is-house? my-house and [myType] of my-house = "mortgage" [set my-house nobody]
    ]

  ]

end

;; reset the global parameters each tick
to reset-globals
  set nupShocked 0
  set ndownShocked 0
  set nUpShockedSell 0
  set nDownShockedSell 0
  set nUpShockedRent 0
  set nDownShockedRent 0
  set nForceSell 0
  set nHomeless 0
  set nIndependentThisTick 0
  set nBirthsThisTick 0
  set nDeathsThisTick 0
  set transactionsFirstTime (list)
  set transactionsRightToBuy (list)
  set medianPriceFirstTime 0
  set medianPriceOfHousesForSale 0
  set medianPriceOfHousesForRent 0
  set medianPriceOfHousesForSocial 0
  set medianSalePriceHouses 0
  set medianRentPriceRentHouses 0
  set medianRentPriceSocialHouses 0
  set medianSalePriceXYLocality 0
  set medianRentPriceXYLocality 0
  set medianSalePriceXYModifyRadius 0
  set medianRentPriceXYModifyRadius 0
  set medianRichReference 0
  set maxRichReference 0
  set nWealth10k 0
  set nWealth10k-50k 0
  set nWealth50k-500k 0
  set nWealth500k-1m 0
  set nWealth1m-2m 0
  set nWealth2m-5m 0
  set nWealth5m 0
  set richReferencesCalculated? false
  set ageOwnershipWealth 0
end

;; update the global parameters each tick
to update-globals
  ;; transactions by first time buyers and right to buy buyers
  ifelse length transactionsFirstTime > 0
  [set medianPriceFirstTime median transactionsFirstTime]
  [set medianPriceFirstTime 0]
  ifelse length transactionsRightToBuy > 0
  [set medianPriceRightToBuy median transactionsRightToBuy]
  [set medianPriceRightToBuy 0]

  ;; monitor the location around XY (used in case experiments related to gentrification are applied)
  if monitor-XY? = true [
    ask patch patch-x patch-y [
      if count houses with [myType = "mortgage"] in-radius locality > 0 [set medianSalePriceXYLocality median [sale-price] of houses with [myType = "mortgage"] in-radius locality]
      if count houses with [myType = "rent"] in-radius locality > 0 [set medianRentPriceXYLocality median [rent-price] of houses with [myType = "rent"] in-radius locality]
      if count houses with [myType = "mortgage"] in-radius modify-price-radius > 0 [
        set medianSalePriceXYModifyRadius median [sale-price] of houses with [myType = "mortgage"] in-radius modify-price-radius
      ]
      if count houses with [myType = "rent"] in-radius modify-price-radius > 0 [set medianRentPriceXYModifyRadius median [rent-price] of houses with [myType = "rent"] in-radius modify-price-radius]
    ]
  ]

  ;; sale and rent prices
  set medianSalePriceHouses median ([sale-price] of houses with [myType = "mortgage" and sale-price > 0])
  set medianRentPriceRentHouses median ([rent-price] of houses with [myType = "rent" and rent-price > 0])
  set medianRentPriceSocialHouses median ([rent-price] of houses with [myType = "social" and rent-price > 0])

  ;; wealth
  if calculate-wealth? = True [
    set nWealth10k count owners with [wealth < 10000 and my-house != "external"]
    set nWealth10k-50k count owners with [wealth >= 10000 and wealth < 50000 and my-house != "external"]
    set nWealth50k-500k count owners with [wealth >= 50000 and wealth < 500000 and my-house != "external"]
    set nWealth500k-1m count owners with [wealth >= 500000 and wealth < 1000000 and my-house != "external"]
    set nWealth1m-2m count owners with [wealth >= 1000000 and wealth < 2000000 and my-house != "external"]
    set nWealth2m-5m count owners with [wealth >= 20000000 and wealth < 5000000 and my-house != "external"]
    set nWealth5m count owners with [wealth >= 5000000 and my-house != "external"]
    set gini-wealth gini-index [wealth] of owners with [my-house != "external"]
    if monitor-ageOwnershipWealth? = true [set ageOwnershipWealth map [hh -> [(list (age / ticksPerYear) (length my-ownership) (wealth))] of hh] (sort owners with [my-house != "external"])]
  ]
end

;; update the visualisation mode based on prices, types or hotspot
to update-visualisation
  ;; the next modes do not need to be called every tick (recommended during runs)
  if visualiseModeCurrent != VisualiseMode [
    if visualiseMode = "Prices" [
      ask houses with [myType = "mortgage"] [set size 0.9 set color scale-color red sale-price (max [sale-price] of houses with [mytype = "mortgage"]) (min [sale-price] of houses with [mytype = "mortgage"])]
      ask houses with [myType = "rent"] [set size 0.9 set color scale-color blue rent-price (max [rent-price] of houses with [mytype = "rent"]) (min [rent-price] of houses with [mytype = "rent"])]
      ask houses with [myType = "social"] [set size 0.9 set color scale-color green rent-price (max [rent-price] of houses with [mytype = "social"]) (min [rent-price] of houses with [mytype = "social"])]
      set visualiseModeCurrent "Prices"
    ]
    if visualiseMode = "Types" [
      ask houses with [myType = "mortgage"] [set size 0.9 set color yellow]
      ask houses with [myType = "rent"] [set size 0.9 set color sky]
      ask houses with [myType = "social"] [set size 0.9 set color green]
      set visualiseModeCurrent "Types"
    ]
  ]
  ;; the next modes have to be called every step (computationally demanding)
  if visualiseMode = "Diversity by prices" [
    ask houses [calculate-diversity]
    ask houses [set color scale-color red diversity (max [diversity] of houses) (min [diversity] of houses)]
    set visualiseModeCurrent "Diversity by prices"
  ]
  if visualiseMode = "Hotspot prices (Getis-Ord)" [
    calculate-G
    ask houses [set color palette:scale-gradient [[0 0 255] [255 255 255] [255 0 0]] G -5 5]
    set visualiseModeCurrent "Hotspot prices (Getis-Ord)"
  ]
end

; force the model to revisualise even if the visualise mode has not changed (only used to update prices when modified)
to force-update-visualisation
  if visualiseMode = "Prices" [
    ask houses with [myType = "mortgage"] [set size 0.9 set color scale-color red sale-price (max [sale-price] of houses with [mytype = "mortgage"]) (min [sale-price] of houses with [mytype = "mortgage"])]
    ask houses with [myType = "rent"] [set size 0.9 set color scale-color blue rent-price (max [rent-price] of houses with [mytype = "rent"]) (min [rent-price] of houses with [mytype = "rent"])]
    ask houses with [myType = "social"] [set size 0.9 set color scale-color green rent-price (max [rent-price] of houses with [mytype = "social"]) (min [rent-price] of houses with [mytype = "social"])]
    set visualiseModeCurrent "Prices"
  ]
  if visualiseMode = "Types" [
    ask houses with [myType = "mortgage"] [set size 0.9 set color yellow]
    ask houses with [myType = "rent"] [set size 0.9 set color sky]
    ask houses with [myType = "social"] [set size 0.9 set color green]
    set visualiseModeCurrent "Types"
  ]
  ;; these modes have to be called every step (computationally demanding)
  if visualiseMode = "Diversity by prices" [
    ask houses [calculate-diversity]
    ask houses [set color scale-color red diversity (max [diversity] of houses) (min [diversity] of houses)]
    set visualiseModeCurrent "Diversity by prices"
  ]
  if visualiseMode = "Hotspot prices (Getis-Ord)" [
    calculate-G
    ask houses [set color palette:scale-gradient [[0 0 255] [255 255 255] [255 0 0]] G -5 5]
    set visualiseModeCurrent "Hotspot prices (Getis-Ord)"
  ]
end

;; colour one house based on the visualiseMode parameter
to colour-house
  if visualiseMode = "Prices" [
    if myType = "mortgage" [set size 0.9 set color scale-color red sale-price (max [sale-price] of houses with [mytype = "mortgage"]) (min [sale-price] of houses with [mytype = "mortgage"])]
    if myType = "rent" [set size 0.9 set color scale-color blue rent-price (max [rent-price] of houses with [mytype = "rent"]) (min [rent-price] of houses with [mytype = "rent"])]
    if myType = "social" [set size 0.9 set color scale-color green rent-price (max [rent-price] of houses with [mytype = "social"]) (min [rent-price] of houses with [mytype = "social"])]
    stop
  ]
  if visualiseMode = "Types" [
    if myType = "mortgage" [set size 0.9 set color yellow]
    if myType = "rent" [set size 0.9 set color sky]
    if myType = "social" [set size 0.9 set color green]
    stop
  ]
  if visualiseMode = "Diversity by prices" [
    set color scale-color red diversity (max [diversity] of houses) (min [diversity] of houses)
  ]
end

;; calculate the diversity (not used in the current version of the model
to calculate-diversity
  ;; define the calculation parameters
  set diversity 0
  let my-neighbours houses-on neighbors
  let min-price min [sale-price] of houses with [myType = "mortgage"]
  let max-price max [sale-price] of houses with [myType = "mortgage"]
  let min-rent min [rent-price] of houses with [myType = "rent"]
  let max-rent max [rent-price] of houses with [myType = "rent"]
  let intervals 3
  let increment-price (max-price - min-price) / intervals
  let increment-rent (max-rent - min-rent) / intervals
  ifelse any? my-neighbours [
    if myType = "mortgage" [
      let threshold min-price
      while [threshold < max-price] [
        let increment-start threshold
        let increment-end threshold + increment-price
        ;; calculate diversity index
        let composite count houses-here with [(sale-price > increment-start) and (sale-price < increment-end)] + count my-neighbours with [sale-price > increment-start and sale-price < increment-end]
        let composite-total count houses-here with [sale-price > increment-start and sale-price < increment-end] + count my-neighbours
        if composite > 0 [set diversity diversity + ( (composite / composite-total) + ln(composite / composite-total) )]
        ;; add to the threshold
        set threshold threshold + increment-price
      ]
    ]
    if myType = "rent" or myType = "social" [
      let threshold min-rent
      while [threshold < max-rent] [
        let increment-start threshold
        let increment-end threshold + increment-rent
        ;; calculate diversity index
        let composite count houses-here with [rent-price > increment-start and rent-price < increment-end]  + count my-neighbours with [rent-price > increment-start and rent-price < increment-end]
        let composite-total count houses-here with [rent-price > increment-start and rent-price < increment-end] + count my-neighbours
        if composite > 0 [set diversity diversity + ( (composite / composite-total) + ln(composite / composite-total) )]
        ;; add to the threshold
        set threshold threshold + increment-rent
      ]
    ]
  ]
  [set diversity 0]
  set diversity diversity * -1
end

;; Calculate hotspot Getis-ord
;; Refer to Appendix in http://jasss.soc.surrey.ac.uk/27/4/5.html for more details
to calculate-G
  ;; mortgage houses
  let sum-price-sqrd 0
  ask houses with [myType = "mortgage" and sale-price > 0] [set sum-price-sqrd sum-price-sqrd + (sale-price * sale-price)]
  ask houses with [myType = "mortgage"] [
    let n count houses with [myType = "mortgage" and sale-price > 0]
    ifelse any? (houses-on neighbors) with [myType = "mortgage" and sale-price > 0] [
      let w 1 / 8
      let sum-w-sqrd 0
      let sum-w w * count (houses-on neighbors) with [myType = "mortgage" and sale-price > 0]
      ask (houses-on neighbors) with [myType = "mortgage" and sale-price > 0] [set sum-w-sqrd sum-w-sqrd + (w * w)]
      let X sum [sale-price] of houses with [myType = "mortgage" and sale-price > 0] / n
      let S sqrt ( (sum-price-sqrd / n) - (X ^ 2) )
      set G ( (w * sum [sale-price] of (houses-on neighbors) with [myType = "mortgage" and sale-price > 0]) - (X * sum-w) ) /
            ( S * sqrt( ( (n * sum-w-sqrd) - (sum-w) ^ 2 ) / (n - 1) ) )
    ]
    [set G 0]
  ]
  ;; rent houses
  let sum-rent-sqrd 0
  ask houses with [myType = "rent" and rent-price > 0] [set sum-rent-sqrd sum-rent-sqrd + (rent-price * rent-price)]
  ask houses with [myType = "rent"] [
    let n count houses with [myType = "rent" and rent-price > 0]
    ifelse any? (houses-on neighbors) with [myType = "rent" and rent-price > 0] [
      let w 1 / 8
      let sum-w-sqrd 0
      let sum-w w * count (houses-on neighbors) with [myType = "rent" and rent-price > 0]
      ask (houses-on neighbors) with [myType = "rent" and rent-price > 0] [set sum-w-sqrd sum-w-sqrd + (w * w)]
      let X sum [rent-price] of houses with [myType = "rent" and rent-price > 0] / n
      let S sqrt ( (sum-rent-sqrd / n) - (X ^ 2) )
      set G ( (w * sum [rent-price] of (houses-on neighbors) with [myType = "rent" and rent-price > 0]) - (X * sum-w) ) /
            ( S * sqrt( ( (n * sum-w-sqrd) - (sum-w) ^ 2 ) / (n - 1) ) )
    ]
    [set G 0]
  ]
  ;; social houses
  let sum-social-sqrd 0
  ask houses with [myType = "social" and rent-price > 0] [set sum-social-sqrd sum-social-sqrd + (rent-price * rent-price)]
  ask houses with [myType = "social"] [
    let n count houses with [myType = "social" and rent-price > 0]
    ifelse any? (houses-on neighbors) with [myType = "social" and rent-price > 0] [
      let w 1 / 8
      let sum-w-sqrd 0
      let sum-w w * count (houses-on neighbors) with [myType = "social" and rent-price > 0]
      ask (houses-on neighbors) with [myType = "social" and rent-price > 0] [set sum-w-sqrd sum-w-sqrd + (w * w)]
      let X sum [rent-price] of houses with [myType = "social" and rent-price > 0] / n
      let S sqrt ( (sum-social-sqrd / n) - (X ^ 2) )
      set G ( (w * sum [rent-price] of (houses-on neighbors) with [myType = "social" and rent-price > 0]) - (X * sum-w) ) /
            ( S * sqrt( ( (n * sum-w-sqrd) - (sum-w) ^ 2 ) / (n - 1) ) )
    ]
    [set G 0]
  ]

end

;; forcibly modify prices in patch XY
to modify-prices
  ; if ticks = 0 (right after initialisation)
  ifelse ticks = 0 [
    ; find the patch
    ask patch patch-x patch-y [
      ; find houses within the modify radius
      ask houses in-radius modify-price-radius [
        ; if user set the price > 0 this implies modifying price at initialisation is turned on
        if initialPrice > 0 [
          set sale-price initialPrice
          ask records with [the-house = self] [set selling-price initialPrice]
        ]
      ]
    ]
  ]
  ; if ticks > 0 (during the run)
  [
    ask patch patch-x patch-y [
      ask houses in-radius modify-price-radius [
        if mPrice > 0 [
          ;; modify the sale-price of the house
          set sale-price mPrice
          ;; create a new record
          let new-record nobody
          hatch-records 1 [
            hide-turtle
            move-to myself
            set date ticks
            set date ticks
            set the-house myself
            set selling-price mPrice
            set renting-price 0
            set new-record self
          ]
          ;; file the record to all the local realtors
          ask turtle-set local-realtors [file-record self new-record]
        ]
      ]
    ]
  ]
end

;; report the gini index
to-report gini-index [ lst ]
;; reports the gini index of the values in the given list
;; Actually returns the gini coefficient (between 0 and 1) - the
;; gini index is a percentage

  let sorted sort lst
  let total sum sorted
  let items length lst
  let sum-so-far 0
  let index 0
  let gini 0
  repeat items [
    set sum-so-far sum-so-far + item index sorted
    set index index + 1
    set gini  gini + (index / items) - (sum-so-far / total)
  ]
  ; only accurate if items is large
  report 2 * (gini / items)
end

;; report the inheritance tax
to-report inheritance-tax [ house-or-price ]
  ;; reports the inheritance-tax for a house based on its sale price
  let house-price 0
  ;; assign the house price based on type of input
  ifelse is-house? house-or-price
  [set house-price [sale-price] of house-or-price]
  [set house-price house-or-price]
  ;; calculate the inheritance tax
  if house-price < 2000000 and house-price > 500000
  [report (house-price - 500000) * 0.4]
  if house-price > 2000000
  [report (house-price - 360000) * 0.4]
  report 0
end

;; forcibly reach a target proportion between mortgage and private rent houses by adjusting the number of investors in the system
;; developed only for testing purposes
;; not recommended in baseline
to manage-targets
  ;; If we are not reaching the target owned to rented percentages
  if TargetOwnedPercent < (count houses with [myType = "mortgage"] / count houses) * 100 and ticks > 0 and ticks < 400 and ticks mod 4 = 0 [
    let potential-investors owners with [myType = "mortgage" and propensity > 1 - investors and my-house != "external" and on-market? = false]
    let home-owners owners with [myType = "mortgage" and length my-ownership = 1 and on-market? = false]
    ;; find the number of required investors to create the balance
    let n-required-investors ( (count houses) - (count houses * (targetOwnedPercent / 100)) ) - count houses with [myType = "rent"]
    ;; increase the capital of the investors so that they can enter the BTL market
    ;; and forcibly evit a number of homebuyers so that their houses can be bought by new investors
    if n-required-investors > 0 [
      ask n-of (0.1 * count potential-investors) potential-investors [set capital capital + medianSalePriceHouses]
      ask n-of (0.1 * count home-owners) home-owners [set capital 0 evict self]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
1032
15
1423
407
-1
-1
5.9
1
10
1
1
1
0
1
1
1
-32
32
-32
32
1
1
1
ticks
30.0

SLIDER
13
92
198
125
InterestRate
InterestRate
0
15
3.7
0.01
1
% annually
HORIZONTAL

SLIDER
14
43
199
76
TicksPerYear
TicksPerYear
4
52
12.0
8
1
NIL
HORIZONTAL

SLIDER
219
409
404
442
nRealtors
nRealtors
1
100
5.0
1
1
NIL
HORIZONTAL

SLIDER
219
445
404
478
RealtorTerritory
RealtorTerritory
1
50
16.0
1
1
patch radius
HORIZONTAL

SLIDER
218
43
403
76
Density
Density
1
100
70.0
1
1
%
HORIZONTAL

SLIDER
219
110
404
143
Owned-Rent-Percentage
Owned-Rent-Percentage
0
100
50.0
1
1
%
HORIZONTAL

SLIDER
838
107
1023
140
HouseMeanLifetime
HouseMeanLifetime
0
500
100.0
1
1
years
HORIZONTAL

SLIDER
220
180
405
213
initialOccupancy
initialOccupancy
0.75
1.25
0.95
0.01
1
fraction
HORIZONTAL

SLIDER
428
382
613
415
Affordability
Affordability
0
100
18.0
1
1
% of annual income
HORIZONTAL

SLIDER
10
226
195
259
MaxLoanToValue
MaxLoanToValue
0
100
90.0
1
1
%
HORIZONTAL

SLIDER
10
458
195
491
MortgageDuration
MortgageDuration
0
40
25.0
1
1
years
HORIZONTAL

SLIDER
433
43
618
76
MeanIncome
MeanIncome
0
90000
30000.0
1000
1
yearly
HORIZONTAL

SLIDER
427
229
612
262
WageRise
WageRise
0
50
0.0
0.01
1
%
HORIZONTAL

SLIDER
427
264
612
297
Savings
Savings
0
100
20.0
1
1
% of surplus income
HORIZONTAL

SLIDER
838
142
1023
175
Locality
Locality
1
10
3.0
1
1
NIL
HORIZONTAL

CHOOSER
2398
686
2490
731
InitialGeography
InitialGeography
"Random" "Clustered"
0

SLIDER
220
293
405
326
price-difference
price-difference
0
25000
5000.0
100
1
NIL
HORIZONTAL

SLIDER
220
323
405
356
rent-difference
rent-difference
0
1000
500.0
100
1
NIL
HORIZONTAL

SLIDER
220
357
405
390
clusteringRepeat
clusteringRepeat
1
5
5.0
1
1
NIL
HORIZONTAL

CHOOSER
2582
686
2674
731
scenario
scenario
"base-line" "raterise 3" "raterise 10" "influx" "influx-rev" "poorentrants" "ltv"
0

SLIDER
639
42
824
75
EntryRate
EntryRate
0
20
20.0
1
1
% yearly
HORIZONTAL

SLIDER
639
73
824
106
ExitRate
ExitRate
0
20
8.0
1
1
% yearly
HORIZONTAL

SLIDER
835
576
1020
609
CycleStrength
CycleStrength
0
80
0.0
5
1
NIL
HORIZONTAL

SLIDER
835
606
1020
639
shock-frequency
shock-frequency
0
1
0.0
0.1
1
NIL
HORIZONTAL

SLIDER
835
640
927
673
Shocked
Shocked
1
50
20.0
1
1
NIL
HORIZONTAL

SLIDER
927
642
1020
675
income-shock
income-shock
0
50
20.0
1
1
NIL
HORIZONTAL

CHOOSER
2489
686
2581
731
new-owner-type
new-owner-type
"random" "all-rent" "all-owned" "contextualized" "Target ratios"
0

SLIDER
640
317
812
350
MaxHomelessPeriod
MaxHomelessPeriod
0
120
16.0
1
1
ticks
HORIZONTAL

SLIDER
837
40
1022
73
HouseConstructionRate
HouseConstructionRate
0
5
1.44
0.01
1
%
HORIZONTAL

BUTTON
1034
449
1151
487
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
3004
370
3116
415
houses for sale
count houses with [for-sale? = true]
17
1
11

PLOT
1910
186
2351
345
Houses
ticks
# houses
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"population" 1.0 0 -5987164 true "" "plot count owners"
"houses" 1.0 0 -16777216 true "" "plot count houses"
"Mortgage houses" 1.0 0 -1184463 true "" "plot count houses with [myType = \"mortgage\"]"
"Rent houses" 1.0 0 -13791810 true "" "plot count houses with [myType = \"rent\"]"
"Mortgage households" 1.0 0 -955883 true "" "plot count owners with [myType = \"mortgage\"]"
"Rent households" 1.0 0 -8630108 true "" "plot count owners with [myType = \"rent\"]"
"Social houses" 1.0 0 -14439633 true "" "plot count houses with [myType = \"social\"]"
"Right-tobuy houses" 1.0 0 -2674135 true "" "plot count owners with [member? \"right-to-buy\" mortgage-type]"

PLOT
1910
20
2350
189
owners
ticks
# owners
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Enter" 1.0 0 -13840069 true "" "plot nEntry"
"Exit" 1.0 0 -13791810 true "" "plot nExit"
"Discouraged" 1.0 0 -2674135 true "" "plot nDiscouraged"
"Renters no house" 1.0 0 -7500403 true "" "plot count owners with [not is-house? my-house and mytype = \"rent\"]"
"owners no hosue" 1.0 0 -16777216 true "" "plot count owners with [not is-house? my-house and mytype = \"mortagage\"]"

PLOT
2770
25
3211
184
Force out number
ticks
# owners
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Evicted Owners" 1.0 0 -13791810 true "" "plot nEvictedMortgage"
"Evicted Renters" 1.0 0 -2674135 true "" "plot nEvictedRent"

PLOT
2770
180
3211
339
Force out (incomes)
ticks
income
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Evicted Owners" 1.0 0 -13791810 true "" "plot meanIncomeEvictedMortgage"
"Evicted Renters" 1.0 0 -2674135 true "" "plot meanIncomeEvictedRent"

SLIDER
219
476
404
509
RealtorOptimism
RealtorOptimism
0
5
1.0
1
1
NIL
HORIZONTAL

SWITCH
546
919
823
952
StampDuty?
StampDuty?
0
1
-1000

SLIDER
427
612
612
645
BuyerSearchLength
BuyerSearchLength
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
219
510
404
543
RealtorMemory
RealtorMemory
10
120
30.0
10
1
ticks
HORIZONTAL

SLIDER
219
545
404
578
min-price-fraction
min-price-fraction
0
0.5
0.2
0.1
1
NIL
HORIZONTAL

SLIDER
219
577
404
610
PriceDropRate
PriceDropRate
0
12
12.0
1
1
% yearly
HORIZONTAL

SLIDER
219
609
404
642
RentDropRate
RentDropRate
0
12
12.0
1
1
% yearly
HORIZONTAL

PLOT
1908
344
2352
503
Prices (median)
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"houses for sale" 1.0 2 -13840069 true "" "plot medianPriceOfHousesForSale"
"all houses" 1.0 0 -16777216 true "" "plot medianSalePriceHouses"
"Sold to FT" 1.0 2 -2674135 true "" "plot medianPriceFirstTime"
"XY Locality" 1.0 0 -6459832 true "" "plot medianSalePriceXYLocality"
"XY ModifyRadius" 1.0 0 -1184463 true "" "plot medianSalePriceXYModifyRadius"
"Right to buy" 1.0 2 -13345367 true "" "plot medianPriceRightToBuy"

PLOT
1910
502
2352
658
Rents (median)
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"XY Locality" 1.0 0 -6459832 true "" "plot medianRentPriceXYLocality * ticksPerYear"
"XY ModifyRadius" 1.0 0 -955883 true "" "plot medianRentPriceXYModifyRadius * ticksPerYear"
"houses for-social" 1.0 2 -1184463 true "" "plot medianPriceOfHousesForSocial * ticksPerYear"
"All social houses" 1.0 0 -14439633 true "" "plot medianRentPriceSocialHouses * ticksPerYear"
"Houses for-rent" 1.0 2 -11221820 true "" "plot medianPriceOfHousesForRent * ticksPerYear"
"private rent houses" 1.0 0 -13345367 true "" "plot medianRentPriceRentHouses * ticksPerYear"

SLIDER
640
503
824
536
savings-to-rent-threshold
savings-to-rent-threshold
1
20
5.0
0.1
1
NIL
HORIZONTAL

SLIDER
640
570
824
603
eviction-threshold-mortgage
eviction-threshold-mortgage
0
3
2.0
0.1
1
NIL
HORIZONTAL

PLOT
2358
495
2749
659
Count "owner" agents on the market
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Mortgage" 1.0 0 -10141563 true "" "plot count owners with [on-market-type = [\"mortgage\"]]"
"Buy-to-let" 1.0 0 -11881837 true "" "plot count owners with [on-market-type = [\"buy-to-let\"]]"
"Rent" 1.0 0 -5298144 true "" "plot count owners with [member? \"rent\" on-market-type]"
"First-time" 1.0 0 -7500403 true "" "plot count owners with [on-market-type = [\"mortgage\"] and first-time? = true]"
"Social" 1.0 0 -1184463 true "" "plot count owners with [on-waiting-list? = true]"

BUTTON
1034
495
1152
531
go nYears
go\nif (ticks / TicksPerYear) >= nYears [setup]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
2769
388
2872
433
Count homeless
nHomeless
17
1
11

MONITOR
2769
343
2872
388
Count occupiers
Count owners with [is-house? my-house]
17
1
11

MONITOR
2769
478
2872
523
Total
Count owners
17
1
11

MONITOR
2874
433
3004
478
on rent market
count owners with [on-market-type = \"rent\"]
17
1
11

MONITOR
2874
343
3004
388
on mortgage market
count owners with [on-market-type = \"mortgage\"]
17
1
11

MONITOR
2874
388
3004
433
on buy-to-let market
count owners with [on-market-type = \"buy-to-let\"]
17
1
11

MONITOR
3004
433
3117
478
houses for rent
count houses with [for-rent? = true]
17
1
11

SLIDER
640
603
824
636
eviction-threshold-rent
eviction-threshold-rent
0
3
1.0
0.1
1
NIL
HORIZONTAL

INPUTBOX
1156
449
1212
529
nYears
400.0
1
0
Number

SLIDER
428
447
614
480
investors
investors
0
1
0.5
0.05
1
fraction
HORIZONTAL

TEXTBOX
1092
406
1242
424
Yellow: Mortgage house
10
44.0
1

TEXTBOX
1219
406
1309
424
Blue: Rent house
10
94.0
1

SLIDER
427
299
612
332
SavingsRent
SavingsRent
0
100
5.0
1
1
% of surplus income
HORIZONTAL

SLIDER
428
480
614
513
upgrade-tenancy
upgrade-tenancy
0
1
0.0
0.05
1
fraction
HORIZONTAL

SLIDER
10
622
197
655
MaxRateDurationM
MaxRateDurationM
1
25
5.0
1
1
years
HORIZONTAL

SLIDER
10
587
197
620
MinRateDurationM
MinRateDurationM
1
25
2.0
1
1
years
HORIZONTAL

SLIDER
10
655
195
688
MinRateDurationBTL
MinRateDurationBTL
1
50
1.0
1
1
years
HORIZONTAL

SLIDER
10
691
195
724
MaxRateDurationBTL
MaxRateDurationBTL
1
50
1.0
1
1
years
HORIZONTAL

SLIDER
220
247
405
280
FullyPaidMortgageOwners
FullyPaidMortgageOwners
0
100
0.0
1
1
%
HORIZONTAL

BUTTON
1226
495
1408
529
Update visualisation
update-visualisation
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

CHOOSER
1226
449
1408
494
VisualiseMode
VisualiseMode
"Types" "Prices" "Diversity by prices" "Hotspot prices (Getis-Ord)"
0

TEXTBOX
1095
434
1381
452
Saturated colours indicate higher prices and lower diversity
10
0.0
1

TEXTBOX
1042
406
1081
425
Types |
10
0.0
1

TEXTBOX
1042
420
1084
438
Prices |
10
0.0
1

TEXTBOX
1095
420
1200
438
Red: Mortgage house
10
14.0
1

TEXTBOX
1219
420
1307
438
Blue: Rent house
10
94.0
1

MONITOR
2768
433
2873
478
Born & imigrants
count owners with [not is-house? my-house]
17
1
11

BUTTON
1034
558
1205
618
interest = mInterest %
go\nif (ticks / TicksPerYear) = mYear [\nset InterestRate mInterest\nset InterestRateFirstTime mInterestFT\nset InterestRateBTL mInterestBTL\nset InterestRateRTB mInterestRTB\n]\nif (ticks / TicksPerYear) >= nYears [stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

INPUTBOX
1415
446
1465
529
mYear
300.0
1
0
Number

INPUTBOX
1206
559
1264
619
mInterest
8.0
1
0
Number

SLIDER
433
112
618
145
CapitalMortgage
CapitalMortgage
0
100
100.0
1
1
% of income
HORIZONTAL

SLIDER
435
146
617
179
CapitalRent
CapitalRent
0
100
52.0
1
1
% of income
HORIZONTAL

TEXTBOX
19
13
85
36
Initialisation
10
0.0
1

TEXTBOX
818
14
866
37
Run
10
0.0
1

BUTTON
629
715
821
759
reset to base-line
reset
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1032
620
1204
679
MaxLoanToValue = pLTV %
go\nif (ticks / TicksPerYear) = mYear [\nset MaxLoanToValue mLTV\nset MaxLoanToValueFirstTime mLTV-FT\nset MaxLoanToValueBTL mLTV-BTL\nset MaxLoanToValueRTB mLTV-RTB\n]\nif (ticks / TicksPerYear) >= nYears [stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

INPUTBOX
1206
620
1264
680
mLTV
60.0
1
0
Number

SWITCH
2398
730
2674
763
Override-Income-Capital
Override-Income-Capital
1
1
-1000

SLIDER
10
791
195
824
RentToRepayment
RentToRepayment
100
160
120.0
1
1
%
HORIZONTAL

SLIDER
12
260
196
293
MaxLoanToValueFirstTime
MaxLoanToValueFirstTime
0
100
90.0
1
1
%
HORIZONTAL

SLIDER
220
215
406
248
FirstTimeBuyersSetup
FirstTimeBuyersSetup
0
100
0.0
1
1
%
HORIZONTAL

SLIDER
639
105
824
138
FirstTimeBuyersStep
FirstTimeBuyersStep
0
100
50.0
1
1
%
HORIZONTAL

SWITCH
546
985
823
1018
StampDuty-B?
StampDuty-B?
0
1
-1000

SWITCH
546
1020
823
1053
StampDuty-C?
StampDuty-C?
0
1
-1000

SWITCH
546
1054
823
1087
StampDuty-D?
StampDuty-D?
0
1
-1000

TEXTBOX
668
995
853
1014
between £250,000 and £925,000
10
0.0
1

TEXTBOX
668
1028
851
1047
between £925,000 and 1,500,000
10
0.0
1

TEXTBOX
668
1060
861
1079
above 1,500,000
10
0.0
1

TEXTBOX
669
924
872
943
for all tiers
13
0.0
1

SLIDER
12
294
196
327
MaxLoanToValueBTL
MaxLoanToValueBTL
0
100
90.0
1
1
%
HORIZONTAL

SLIDER
10
490
195
523
MortgageDurationFirstTime
MortgageDurationFirstTime
0
40
40.0
1
1
years
HORIZONTAL

SLIDER
10
523
195
556
MortgageDurationBTL
MortgageDurationBTL
0
40
25.0
1
1
years
HORIZONTAL

SLIDER
836
266
929
299
MinAge
MinAge
0
100
21.0
1
1
NIL
HORIZONTAL

SLIDER
929
266
1022
299
MaxAge
MaxAge
0
100
61.0
1
1
NIL
HORIZONTAL

SLIDER
836
460
929
493
MinDeathAge
MinDeathAge
0
100
61.0
1
1
NIL
HORIZONTAL

SLIDER
929
460
1022
493
MaxDeathAge
MaxDeathAge
0
100
90.0
1
1
NIL
HORIZONTAL

SLIDER
836
298
1018
331
MeanAge
MeanAge
0
100
46.0
1
1
NIL
HORIZONTAL

SLIDER
836
495
1019
528
MeanDeathAge
MeanDeathAge
0
100
82.0
1
1
NIL
HORIZONTAL

SLIDER
836
395
929
428
MinBreedAge
MinBreedAge
0
100
22.0
1
1
NIL
HORIZONTAL

SLIDER
929
396
1022
429
MaxBreedAge
MaxBreedAge
0
100
40.0
1
1
NIL
HORIZONTAL

SLIDER
836
427
1019
460
MeanBreedAge
MeanBreedAge
0
100
33.0
1
1
NIL
HORIZONTAL

SLIDER
836
332
929
365
MinChildren
MinChildren
0
10
0.0
1
1
NIL
HORIZONTAL

SLIDER
929
332
1022
365
MaxChildren
MaxChildren
0
10
4.0
1
1
NIL
HORIZONTAL

SLIDER
836
365
1019
398
MeanChildren
MeanChildren
0
10
2.0
1
1
NIL
HORIZONTAL

PLOT
2358
20
2749
186
Age Histogram
NIL
NIL
0.0
90.0
0.0
10.0
true
false
"" ""
PENS
"Age" 1.0 1 -16777216 true "" "histogram ([age / TicksPerYear] of owners)\nset-histogram-num-bars 100"

INPUTBOX
1265
620
1332
680
mLTV-FT
60.0
1
0
Number

INPUTBOX
1329
620
1397
680
mLTV-BTL
60.0
1
0
Number

BUTTON
1032
740
1204
799
RentToRepayment = mRTR
go\nif (ticks / TicksPerYear) = mYear [\nset RentToRepayment mRTR\n]\nif (ticks / TicksPerYear) >= nYears [stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

INPUTBOX
1206
740
1464
800
mRTR
140.0
1
0
Number

BUTTON
1033
798
1204
845
StampDuty? = mSD
go\nif (ticks / TicksPerYear) = mYear [\nset StampDuty-A? mSD-A\nset StampDuty-B? mSD-B\nset StampDuty-C? mSD-C\nset StampDuty-D? mSD-D\nset StampDuty-Rates mSD-Rates\n]\nif (ticks / TicksPerYear) >= nYears [stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SWITCH
1331
799
1421
832
mSD-A
mSD-A
0
1
-1000

SWITCH
1421
799
1511
832
mSD-B
mSD-B
0
1
-1000

SWITCH
1510
799
1600
832
mSD-C
mSD-C
0
1
-1000

BUTTON
1034
876
1203
936
MortgageDuration = mDuration
go\nif (ticks / TicksPerYear) = mYear [\nset MortgageDuration mDuration\nset MortgageDurationFirstTime mDurationFT\nset MortgageDurationBTL mDurationBTL\nset MortgageDurationRTB mDurationRTB\n]\nif (ticks / TicksPerYear) >= nYears [stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

INPUTBOX
1292
876
1386
936
mDurationFT
40.0
1
0
Number

SLIDER
13
124
198
157
InterestRateFirstTime
InterestRateFirstTime
0
15
3.7
0.01
1
% annually
HORIZONTAL

SLIDER
13
156
198
189
InterestRateBTL
InterestRateBTL
0
15
3.7
0.01
1
% annually
HORIZONTAL

INPUTBOX
1265
559
1332
619
mInterestFT
8.0
1
0
Number

INPUTBOX
1330
559
1397
619
mInterestBTL
8.0
1
0
Number

INPUTBOX
1204
876
1293
936
mDuration
25.0
1
0
Number

INPUTBOX
1386
876
1473
936
mDurationBTL
25.0
1
0
Number

PLOT
2358
186
2749
346
Births, Independents and Deaths pet tick
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Births" 1.0 0 -13840069 true "" "plot nBirthsThisTick"
"At Independence Age" 1.0 0 -13791810 true "" "plot nIndependentThisTick"
"Deaths" 1.0 0 -2674135 true "" "plot nDeathsThisTick"

SLIDER
836
232
1017
265
IndependenceAge
IndependenceAge
0
100
21.0
1
1
NIL
HORIZONTAL

SWITCH
836
197
1017
230
simulate-aging?
simulate-aging?
0
1
-1000

SLIDER
836
526
1019
559
ParentToChildCapital
ParentToChildCapital
0
100
100.0
1
1
%
HORIZONTAL

SLIDER
218
76
403
109
MaxDensity
MaxDensity
0
100
100.0
1
1
%
HORIZONTAL

PLOT
2358
346
2749
496
Independents on market
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Independent rent" 1.0 0 -5298144 true "" "plot nIndependentRent"
"Independent-mortgage" 1.0 0 -10141563 true "" "plot nIndependentMortgage"

INPUTBOX
1204
936
1550
996
mMaxDensity
100.0
1
0
Number

BUTTON
1034
936
1204
996
MaxDensity = mMaxDensity
go\nif (ticks / TicksPerYear) = mYear [\nset MaxDensity mMaxDensity\n]\nif (ticks / TicksPerYear) >= nYears [stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SWITCH
1470
658
1892
691
calculate-wealth?
calculate-wealth?
0
1
-1000

PLOT
1474
186
1896
346
Wealth
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"wealth < 10k" 1.0 0 -2674135 true "" "plot nwealth10k"
"10k < wealth < 50k" 1.0 0 -14439633 true "" "plot nwealth10k-50k"
"50k < wealth < 500k" 1.0 0 -13791810 true "" "plot nwealth50k-500k"
"500k < wealth < 1m" 1.0 0 -5825686 true "" "plot nwealth500k-1m"
"1m < wealth < 2m" 1.0 0 -8630108 true "" "plot nwealth1m-2m"
"2m < wealth < 5m" 1.0 0 -2064490 true "" "plot nWealth2m-5m"
"wealth > 5m" 1.0 0 -1184463 true "" "plot nWealth5m"

PLOT
1470
503
1892
659
Gini
NIL
NIL
0.0
10.0
0.6
1.0
true
false
"" ""
PENS
"Gini" 1.0 0 -16777216 true "" "plot gini-wealth"

SWITCH
546
1085
708
1118
Inheritance-tax?
Inheritance-tax?
1
1
-1000

TEXTBOX
1038
536
1350
554
go nYears and at mYear apply the following
12
0.0
1

BUTTON
1034
845
1205
878
inheritance-tax? = mInheritance
go\nif (ticks / TicksPerYear) = mYear [\nset Inheritance-tax? mInheritance\n]\nif (ticks / TicksPerYear) >= nYears [stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SWITCH
1206
845
1473
878
mInheritance
mInheritance
0
1
-1000

TEXTBOX
2408
670
2558
688
Used for debugging (keep as is)
10
0.0
1

TEXTBOX
1668
666
1898
692
Do not toggle during the runs
10
0.0
1

INPUTBOX
2012
690
2062
750
patch-x
-15.0
1
0
Number

INPUTBOX
2062
690
2112
750
patch-y
-15.0
1
0
Number

SLIDER
2012
750
2258
783
modify-price-radius
modify-price-radius
0
10
6.0
1
1
NIL
HORIZONTAL

BUTTON
1909
690
2011
782
modify-prices
if ticks = 0 [\nmodify-prices\nforce-update-visualisation\n]\ngo\nif (ticks / TicksPerYear) = mYear [\nmodify-prices\nforce-update-visualisation\n]\nif (ticks / TicksPerYear) >= nYears [stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

INPUTBOX
2186
690
2260
750
mPrice
1000000.0
1
0
Number

INPUTBOX
2110
690
2185
750
initialPrice
500000.0
1
0
Number

PLOT
1472
20
1893
186
Count owners based on number of owned houses
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"0" 1.0 0 -2674135 true "" "plot count owners with [length my-ownership = 0]"
"1" 1.0 0 -955883 true "" "plot count owners with [length my-ownership = 1]"
"2" 1.0 0 -13791810 true "" "plot count owners with [length my-ownership = 2]"
"3" 1.0 0 -14835848 true "" "plot count owners with [length my-ownership = 3]"
">3" 1.0 0 -8630108 true "" "plot count owners with [length my-ownership > 3]"

BUTTON
2258
690
2350
783
Modify now
modify-prices\nforce-update-visualisation
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SWITCH
1910
658
2351
691
monitor-xy?
monitor-xy?
1
1
-1000

MONITOR
2399
765
2586
810
NIL
mediansalepricexymodifyradius
17
1
11

SWITCH
1780
308
1897
341
capital-wealth?
capital-wealth?
1
1
-1000

PLOT
1472
346
1895
502
Wealth histogram
NIL
NIL
10000.0
2000000.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram ([wealth] of owners)\nset-histogram-num-bars 100"

SLIDER
20
904
275
937
initial-external-landlords
initial-external-landlords
0
100
0.0
1
1
% of all households
HORIZONTAL

SWITCH
23
870
277
903
external-landlords?
external-landlords?
1
1
-1000

SLIDER
20
938
275
971
external-landlords-per-tick
external-landlords-per-tick
0
100
0.0
1
1
% of new households
HORIZONTAL

SLIDER
288
914
530
947
rich-immigrants
rich-immigrants
0
100
0.0
1
1
% of mortgage immigrants
HORIZONTAL

CHOOSER
288
870
531
915
rich-reference
rich-reference
"XY modify radius houses" "All houses"
1

SLIDER
2682
686
2867
719
TargetOwnedPercent
TargetOwnedPercent
0
100
50.0
1
1
NIL
HORIZONTAL

SWITCH
2682
719
2867
752
force-target
force-target
1
1
-1000

SLIDER
219
144
404
177
initial-social-houses
initial-social-houses
0
100
50.0
1
1
% of rent houses
HORIZONTAL

SLIDER
837
74
1022
107
new-social-houses
new-social-houses
0
100
10.0
1
1
% of built
HORIZONTAL

SLIDER
432
77
619
110
initial-max-income-social
initial-max-income-social
0
100000
32000.0
1000
1
yearly
HORIZONTAL

SLIDER
429
691
616
724
run-max-income-social
run-max-income-social
0
100000
30000.0
1000
1
yearly
HORIZONTAL

SLIDER
429
659
616
692
nCouncils
nCouncils
1
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
220
679
405
712
social-to-private-rent
social-to-private-rent
0
100
50.0
1
1
% of rent price
HORIZONTAL

SLIDER
427
545
630
578
propensity-social-threshold
propensity-social-threshold
0
1
0.5
0.05
1
NIL
HORIZONTAL

SLIDER
640
635
825
668
eviction-threshold-social
eviction-threshold-social
0
3
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
427
579
630
612
Right-To-Buy-threshold
Right-To-Buy-threshold
0
10
10.0
1
1
years
HORIZONTAL

SLIDER
640
535
827
568
savings-to-social-threshold
savings-to-social-threshold
0
10
1.2
0.1
1
NIL
HORIZONTAL

SLIDER
428
333
615
366
SavingsSocial
SavingsSocial
0
100
5.0
1
1
% of surplus income
HORIZONTAL

SLIDER
432
180
617
213
CapitalSocial
CapitalSocial
0
100
10.0
1
1
% of income
HORIZONTAL

SLIDER
13
192
200
225
InterestRateRTB
InterestRateRTB
0
15
3.7
0.01
1
% annually
HORIZONTAL

SLIDER
13
326
198
359
MaxLoanToValueRTB
MaxLoanToValueRTB
0
100
90.0
1
1
%
HORIZONTAL

SLIDER
10
555
195
588
MortgageDurationRTB
MortgageDurationRTB
0
40
25.0
1
1
years
HORIZONTAL

SLIDER
10
724
195
757
MinRateDurationRTB
MinRateDurationRTB
0
25
2.0
1
1
years
HORIZONTAL

SLIDER
10
757
195
790
MaxRateDurationRTB
MaxRateDurationRTB
0
25
5.0
1
1
years
HORIZONTAL

SLIDER
427
513
630
546
propensity-wait-for-RTB-threshold
propensity-wait-for-RTB-threshold
0
1
0.0
0.05
1
NIL
HORIZONTAL

SLIDER
200
645
428
678
max-price-RTB
max-price-RTB
0
200
100.0
1
1
% of median for-sale
HORIZONTAL

TEXTBOX
1312
406
1406
425
Green: Social house
10
64.0
1

TEXTBOX
1312
420
1415
438
Green: Social house
10
64.0
1

BUTTON
1034
995
1204
1028
Right-to-buy? = mRTB
go\nif (ticks / TicksPerYear) = mYear [set Right-to-buy? mRTB]\nif (ticks / TicksPerYear) >= nYears [stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SWITCH
430
725
616
758
Right-to-buy?
Right-to-buy?
0
1
-1000

SWITCH
1204
995
1307
1028
mRTB
mRTB
0
1
-1000

INPUTBOX
1397
559
1463
619
mInterestRTB
8.0
1
0
Number

INPUTBOX
1397
619
1463
679
mLTV-RTB
60.0
1
0
Number

INPUTBOX
1473
876
1551
936
mDurationRTB
25.0
1
0
Number

SLIDER
640
350
812
383
onMarketPeriodBTL
onMarketPeriodBTL
0
120
8.0
1
1
ticks
HORIZONTAL

SLIDER
640
383
812
416
cooldownPeriodBTL
cooldownPeriodBTL
0
120
12.0
1
1
ticks
HORIZONTAL

SLIDER
640
415
812
448
onMarketPeriodMortgage
onMarketPeriodMortgage
0
120
8.0
1
1
ticks
HORIZONTAL

SLIDER
640
449
812
482
cooldownPeriodMortgage
cooldownPeriodMortgage
0
120
12.0
1
1
ticks
HORIZONTAL

TEXTBOX
15
29
182
49
Number of steps per year
8
0.0
1

TEXTBOX
15
80
182
100
Mortgage parameters
8
0.0
1

TEXTBOX
442
30
609
50
Households' income and capital
8
0.0
1

TEXTBOX
438
217
605
237
Households' wages and savings
8
0.0
1

TEXTBOX
434
370
601
390
Households' financial behaviours
8
0.0
1

TEXTBOX
224
30
391
50
Initial houses and households
8
0.0
1

TEXTBOX
838
183
1005
219
Aging and inheritance
8
0.0
1

TEXTBOX
436
646
603
666
Social housing councils
8
0.0
1

TEXTBOX
225
393
392
413
Realtors
8
0.0
1

TEXTBOX
555
860
722
880
Taxes
8
0.0
1

TEXTBOX
36
855
256
874
External landlords (living outside of the system)
8
0.0
1

TEXTBOX
839
28
1006
48
Houses construction and lifetime
8
0.0
1

TEXTBOX
226
280
393
300
Clustering by prices and rents
8
0.0
1

TEXTBOX
843
563
1010
583
Random income shocks
8
0.0
1

TEXTBOX
646
28
813
48
Immigrants and emigrants
8
0.0
1

TEXTBOX
648
305
815
325
Discouragement and cooldown
8
0.0
1

TEXTBOX
646
490
813
510
Eviction thresholds
8
0.0
1

CHOOSER
828
714
1021
759
Baseline-type
Baseline-type
"Weekly step" "1-month step" "3-month step"
1

SWITCH
1470
690
1892
723
monitor-ageOwnershipWealth?
monitor-ageOwnershipWealth?
1
1
-1000

SLIDER
202
713
428
746
max-rent-social
max-rent-social
0
200
120.0
1
1
% of median for-rent
HORIZONTAL

SLIDER
640
227
813
260
social-lag
social-lag
0
6
1.0
1
1
month(s)
HORIZONTAL

SLIDER
640
162
813
195
mortgage-lag
mortgage-lag
0
6
3.0
1
1
month(s)
HORIZONTAL

SLIDER
640
260
813
293
rent-lag
rent-lag
0
6
1.0
1
1
month(s)
HORIZONTAL

SLIDER
640
195
813
228
RTB-lag
RTB-lag
0
6
3.0
1
1
month(s)
HORIZONTAL

TEXTBOX
644
148
811
168
Transactions lags
8
0.0
1

SLIDER
12
359
200
392
MaxLoanToIncome
MaxLoanToIncome
1
20
4.5
0.5
1
x Income
HORIZONTAL

SLIDER
11
391
199
424
MaxLoanToIncomeFT
MaxLoanToIncomeFT
1
20
4.5
0.5
1
x Income
HORIZONTAL

SLIDER
11
424
199
457
MaxLoanToIncomeRTB
MaxLoanToIncomeRTB
1
20
4.5
0.5
1
x Income
HORIZONTAL

BUTTON
1032
679
1204
739
MaxLoanToIncome = pLTI
go\nif (ticks / TicksPerYear) = mYear [\nset MaxLoanToIncome mLTI\nset MaxLoanToIncomeFT mLTI-FT\nset MaxLoanToIncomeRTB mLTI-RTB\n]\nif (ticks / TicksPerYear) >= nYears [stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

INPUTBOX
1206
681
1265
741
mLTI
6.0
1
0
Number

INPUTBOX
1266
681
1331
741
mLTI-FT
6.0
1
0
Number

INPUTBOX
1331
681
1398
741
mLTI-RTB
6.0
1
0
Number

SLIDER
427
414
613
447
Affordability-rent
Affordability-rent
0
100
33.0
1
1
% if income
HORIZONTAL

SLIDER
632
668
832
701
MaxForRentPeriodPoorLandlord
MaxForRentPeriodPoorLandlord
0
12
12.0
1
1
Ticks
HORIZONTAL

CHOOSER
546
874
824
919
StampDuty-Rates
StampDuty-Rates
"Up to 31 March 2025" "From 1 April 2025"
0

CHOOSER
1206
799
1332
844
mSD-Rates
mSD-Rates
"Up to 31 March 2025" "From 1 April 2025"
1

SWITCH
546
952
823
985
StampDuty-A?
StampDuty-A?
0
1
-1000

TEXTBOX
669
962
851
980
between £125,000 and £250,000
10
0.0
1

SWITCH
1600
799
1690
832
mSD-D
mSD-D
0
1
-1000

@#$#@#$#@
## Model description

The model simulates the UK housing market while considering the mortgage market, private rent market and social housing market. The model includes two types of agents: (1) households; and (2) realtors. Households behaviours are financially driven, and they aim to find a house to avoid being homeless, with some aiming to invest in the housing market and become landlord. Realtors are real estate agents that aim to evaluate the prices and rent sof the houses within their bounded rationality. 

For more details, and to refer to this model, see: Gamal, Yahya, Elsenbroich, Corinna, Gilbert, Nigel, Heppenstall, Alison and Zia, Kashif (2024) 'A Behavioural Agent-Based Model for Housing Markets: Impact of Financial Shocks in the UK' Journal of Artificial Societies and Social Simulation 27 (4) 5 <http://jasss.soc.surrey.ac.uk/27/4/5.html>. doi: 10.18564/jasss.5518

N.B. The model is not strictly calibrated to the UK context, so results from this model should be approached as inidcators of expected trends given changes in the financial environment.


## Model updates

Versions "[xx].[xx]" has a full user interface (e.g., 18.4)
Versions "A[xx].[xx]" has a simplified user interface (e.g., A18.4)

Version xx.yy.zz
xx --> major version update
yy --> minor version update
zz --> debugging version update

The versions submitted to JASSS are 18.4 and 18.4.2

Version 19.1.1 (YG)

1. Added the base 3% (until March 2025) and 5% stamp duty (after april 2025) for households on the buy-to-let market.
	- `stamp-duty-land-tax` function takes an extra string input for the type of market the household is using. This is checked to either add or skip the `base` values of either 3% or 5%  

Version 19.1.0 (YG)

1. Commented on all the code for clarity
2. Minor modifications for a cleaner UI and more readable graphs

Version 19.0.20 (YG)

1. Bugs
	- Addressed an issue where evicted households did not check if someone made an offer on the houses they are evicting. This is a further safegaurd as after the modifications in 19.0.19, errors still occured (at a lower frequency) due to having households that have an expected-move-date to a house that is no longer offered for-rent. The model has been tested rigorously and the infrequent errors ceased to exist.
	- Fixed a bug during calculating wealth where the realtor selected for evaluating the sale-price of houses was based on the highest evaluator for the rent-price (rather than the sale-price)
	- Fixed an issue where the `reset-empty-houses` function (called in `new-house` during the runs) accessed houses offered-to households and modified their rents and prices. In many cases, this caused an increase in the rent or sale price, which can be beyond the budget of the household that made an offer. This was on of the causes of the high number of forced evictions despite no changes in the financial restrictions.
2. [Missed adding from version 18.4.2 JASSS paper] Modified the decision tree of not-well-off households with more than one house (landlords). These households now try to rent the house yielding the lowest profit with a higher rent instead of selling it. To achieve this, the following parameters and functions were added:
	- Added `surplus-rent` parameter for `owners` to keep track of the rent of each house compared to its repayment. This represents the profit an `owner` makes from each `my-ownership`.
	- Added `on-market-period` parameter for `houses` to keep track of the number of ticks each house has been on the market.
	- Added `MaxForRentPeriodPoorLandlord` input slider to represent the maximum number of ticks a poor (`not-well-off`) `owner` can wait for a house offered for rent to be rented.
	- `force-sell-rent` replaces the `force-sell` function. `force-sell-rent` goes through the following decision tree for the `not-well-off` `owners`:
		- Check if one of the houses has been offered `for-rent?` for longer than the `MaxForRentPeriodPoorLandlord`. If so, put that house on the "mortgage" market for sale to gain capital.
		- Check if there are no houses offered for rent from `my-ownership`; meaning all the houses are occupied. If so, select the house with the lowest respective `surplus-rent`, `evict` the `my-occupier` of the `house` and put the `house` on the "mortgage" market for sale.
4. Added the modifications to the stamp duty from 1 April 2025 following the Labour government budget (2% tax for prices between £125,000 and £250,000). Added the following input parameters:
	- `StampDuty-Rates` representing the version of the stamp duty tax used (before April 2025 or after April 2025)
	- `StampDuty-D` reprenting the highest stamp duty rate. `StampDuty-A` was modified to reprent the newly introduced 2% brackes, and the subsequent variables were adjusted accordingly (see UI)
	- `mSD-D` and `mSD-Rates` added to modify the new stamp duty variables at `mYear`
5. Code cleaning
	- Shortened the `reset` function by removing the repitions of the baseline parameters with the same values across all baseline types.
	- `mYear` is no longer rest back to 300 when pressing the `reset to baseline` button

Version 19.0.19 (YG)

1. Bugs
	- Addressed an issue where households on the mortgage" and "buy-to-let" markets can get discouraged while waiting for their `expected-move-date` to reach the `ticks` value. This caused a significant drop in prices and errors, especially in the 3-months per tick runs.
	- Addressed an issue where mortgage households owning more than one house die without removing any offers made on their rent houses by households that are still waiting for their `expected-move-date`. This was not necessary prior to adding the lag periods between making an offer and making a transaction.
	- Addressed the same issue as in the previous point where mortgage households die without checking if anyone made an offer on the house they currently occupied. This caused infrequent bugs (1 in each 10 runs).
2. Loan-To-Income (LTI) ratios
	- Added `MaxLoanToIncome`, `MaxLoanToIncomeFT` and `MaxLoanToIncomeRTB` sliders in the interface
	- During the runs, households consider both the maximum mortgage based on the interest rate and LTV and the maximum mortgage based on the LTI ratios. They are restricted to the lower value of these two mortgage caclulations. This is applied in the `manage-market-participation` function and the `make-offer` function.

Version 19.0.17 (YG)

1. Bugs
	- Addressed issues where relatively rich households on the waiting list (`on-market-type` includes "social") would enter the mortgage market while remaining on the waiting list. These households were later not called in `make-offers` or `trade-houses` as their conidtions assume that the "mortgage" and "buy-to-let" markets do not allow households to participate in any other market. 

Version 19.0.16 (YG)

1. Social housing rent evaluation
	- Addressed very rare cases where the evaluated social housing base rent prices would exceed the average rent prices of the realtor. Currently, the final reported rent price for social housing can exceed the average rents in the realtors territory ONLY if the social housing `quality` is high enough to generate a high `multiplier` that significantly increases the evaluated base rent price.
	- Added the input parameter `max-rent-social` to control the cap of the reported social rent as a percentage of the `average-rents` of the respective `realtor`. This assures the quality multiplier does not significantly increase the rent.
2. Added transaction lags from between making offers and acquiring houses.
	- Added the following input paramters
		- `mortgage-lag`
		- `RTB-lag`
		- `rent-lag`
		- `social-lag`
	- Added the following state variables for `owners`
		- `expected-move-date` 
	- `follow-chain` now checks the `expected-move-date` of the next household in the chain. If it is higher than that of the household executing the `follow-chain` function, the function returns the higher `expected-move-date`. This is then allocated as the `expected-move-date` of the hosuehold that executed the function (meaning the household delays its move date). For clarity, `follow-chain` can return:
		- `true` --> the chain is true and all checked `expected-move-date` do not contradict
		- `false` --> the chain is false
		- integer --> the chain is true, but the last checked `expected-move-date` contradicts with the executer of the chain
	- In `trade-houses`, the model currently differentiates between buyers that made an offer and those that did not make an offer. `make-offer` is now executed on buyers that did not make offers and `follow-chain` is executed on those that made an offer and reached their `expected-move-date`
	- `owners-leave` now assures all the households leaving the system check if they have a house in their `made-offer-on` parameter. If so, that `house` modifies its `offered-to` parameter to remove the record of that owner.
	- `manage-age` now applies the process mentioned in the previous bullet point for dying households.
	- `manage-discouraged` now does not remove households who made an offer and are waiting for their `expected-move-date`, even if those households exceeded their maximum homeless period.
3. Assured well-off in social houses do not wait for the right-to-buy scheme if `right-to-buy` is turned off.
	- In `manage-market-participation`, when identifying the well-off households on the social market, differentiated between cases where `right-to-buy?` is turned off and cases where it is turned on.
3. Bugs
	- Addressed rare cases in `demolish-houses` where the occupier of a demolished rent or social house would enter the "rent" or "social" market even if it is well-off. This led to more frequent errors when `right-to-buy?` is turned off.
	- Addressed rare cases in `evict` when a household owning more than one house attempts to `evict` an occupier that happens to be well-off and ends up joining the "rent" market despite already being on the "mortgage" market.	

Version 19.0.15 (YG)

1. Bugs
	- Addressed an issue where the `realtorMemory` parameter was not modified to reflect the changes in `ticksPerYear`. This led to higher than intended evaluations of houses on the rent and social housing market - particularly for runs with high `ticksPerYear` values.
	- Fixed an issue where `priceDropRate` and `rentDropRate` were applied per tick instead of annualy.

Version 19.0.14 (YG)

1. Addressed an issue where the `houseConstructioRate` was applied every tick regardless of the number of `ticksPerYear`. This led to building more houses than intended in runs with higher `ticksPerYear` (shorter time scale per tick).
2. Modified the entry and exit rate percentages of households to be applied annually rather than each tick. This makes the runs with similar entry and exit rates consistent regardless of the valuie of the `ticksPerYear`.
3. Assured that the model does not ignore the cases where the entry, exit and houses demolition are less than 1 per tick. Ignoring them caused issues in runs with high `ticksPerYear` where the number of entries, exits and demolitions rarely exceed 1 per tick.  For instance, if the percentage of owners entry dictates 2.8 household should enter the system at tick 1. The model will introduce 2 agents at tick 1 and move the remaining 0.8 portion to the next tick. If the residual portion in tick 2 and tick 1 adds up to at least 1. An extra households enters the market at tick 2. Beyond this, the remaining residual portion is moved to tick 3, and so on.
4. Modified the rent monitors to represent the annual rent rather than the rent per tick. Previous to this, the observed rent values varied based on the value of the `ticksPerYear` parameter
5. Added a condition that realtors does not evaluate houses above the mean rent in their awareness neighbourhood. This still allows for high social housing rents as the mean rent in a realtor's neighbourhood may be well above the mean rent inhe whole system.
6. Added a maximum time  for households to spend on the "mortgage" or "buy-to-let" market as long as they are not homeless (homeless hosueholds follow the normal discouragement periods)
	- Added `onMarketPeriodBTL` and `onMarketPeriodMortgage` sliders to input the maximum number of ticks households can spend on the buy-to-let and mortgage markets respectively
	- Added `time-on-market` parameter to `owners` to monitor the number of ticks a household has been on the market
7. Added a cooldown time before households can rejoing the "mortgage" or "buy-to-let" market
	- Added `cooldownPeriodBTL` and `cooldownPeriodMortgage` sliders to input the number of ticks households spend on cooldown before they can rejoin the buy-to-let and mortgage market respectively
	- Added `on-cooldown?` parameter to `owners` to monitor whether the household is on cooldown or not
	- Added `on-cooldown-type` parameter to `owners` to track which market the household left before going into the cooldown state
	- Added `time-on-cooldown` parameter to `owners` to monitor the number of tick the households has been on cooldown
8. Updated interface for easier navigation of input parameters
9. Added a `baseline-type` parameter to quickly switch to runs with different `ticksPerYear`
10. Bugs:
	- Corrected an issue where the `manage-surplus-income` function added the `income / 4` every tick to the surplus instead of the `income / ticksPerYear`. This led to a significant increase in savings for runs with high values of `ticksPerYear`.
	- Addressed an issue where "social" `houses` were not assigned to the `vacant-houses` list of its `public-owner` when the ocupier dies

Note: poits 6 and 7 are previously applied in version 18.4.2 as part of the ABM modifications fo the JASSS paper revisions.

Version 19.0.13 (YG)

1. Added the following input parameters to allow for changing the interest rate, LTV and mortgage duration in the right-to-buy market at `mYear` during the runs:
	- `mInterestRTB` --> interest rate at `mYear` for the right-to-buy scheme
	- `mLTV-RTB` --> LTV at `mYear` for the right-to-buy scheme
	- `mDurationRTB` --> Mortgage duration at `mYear` for the right-to-buy scheme
	
2. Bugs
	- Fixed an issue where rates for the the right-to-buy mortgages were updated to the normal mortgage duration (applied after first fixed rate duration ends).
	- Fixed an issue where rent-prices of social houses were not discounted if the realtor finds social houses within its awareness neighbourhood when setting the rent. This led to the deviation of the median rent price of social houses to be equal to that of the private rental market in long runs.
	- Fixed an issue where `houses` with `myType = "social"` were not demolished when at the end of their lifetime. This led to an increase in the number of social houses in long runs.


Version 19.0.12 (YG)

1. Bugs (during development)
	- Fixed an issue at setup where the occupied social houses are not removed from the `vacant-houses` list of the respective `public-sector` agent. This led to many cases where a house become occupied by two `owner` agents at the first run step. Subsequenty, errors occured when two households attempt to buy the same house through a right-to-buy scheme.
	- Fixed an issue where discouraged homeless `owners` on the "social" market do not get removed from the respective waiting lists they applied to. This created longer than intended `waiting-list` variables with many `nobody` elements.
	- Fixed an issue at setup where `my-occupier` of houses assigned to owners of type social was set to `nobody` (instead of the owner). This led to errors during the house transactions in the right-to-buy market.
	- Fixed an issue where houses the valuation of houses on the right-to-buy scheme reported prices without considering discounts. This led to cases where the median price of houses on the right-to-buy scheme become significantly higher than the prices of houses for sale on the mortgage market.
	- Fixed an issue where hot-spot visualisations compared social houses to rent houses instead of other soical houses.
	
Version 19.0.11 (YG)

1. Added a social housing market
	- `houses` can have `myType` of "social"
	- `owners` can have `myType` of "social", and when they join the "social" housing market they join a waiting list (see next bullet point)
	- Added a `public-sector` agent type that owns houses of type "social"
		- The `public-sector` agent keeps track of the vacant social houses and the waiting list to assign social housing
		- More than one `public-sector` agent can exist in the same run
	- Added the following input parameters:
		- propensity-social-threshold --> the probability a household will join the social housing market
		- initial-social-houses --> the percentage of rent houses that are assigned a type of social
		- new-social-houses --> the percentage of newly built houses that are of type social
		- initial-max-income-sicial --> the maximum income of a household of type social at initialisation
		- run-max-income-sicial --> the maximum income of an immigrant household of type social at during the run
		- SavingsSocial --> the percent of savings made from the surplus income of an owner of type social
		- capitalSocial --> the percentage of income that social households have as capital at initialisation
		- nCouncils --> the number of social housing councils
		- social-to-private-rent --> the ratio between the private social rent price to the private rent price
		- eviction-threshold-social --> the minimum ratio between rent and income (considering affordability) that triggers eviction (higher means it becomes more difficult to evict)
2. Added a right-to-buy housing market
	- Only `owners` of type "social" can access the right-to-buy market to purchase their current `my-house` (which is always of type "social")
	- Added the following input parameters to control the conditions for entering the right-to-buy housing market
		- savings-to-social-threshold --> the ratio between the savings and the price of the social house required to enter the right-to-buy market
		- right-to-buy-threshold --> the number of years required before being eligible for a right-to-buy-scheme		
		- propensity-wait-for-RTB-threshold --> the probability a household will wait for a right-to-buy scheme despite being well off before meeting the criteria
		- max-price-RTB --> the percentage of the median prices of houses for sale on the normal mortgage market that dictate the price cap for houses on a right-to-buy scheme
		- InterestRateRTB --> the interest rate for the right-to-buy scheme
		- MaxLoanToValueRTB --> the maximum LTV for the right-to-buy-scheme
		- MortgageDurationRTB --> the total mortgage duration for the right-to-buy-scheme
		- MinRateDurationRTB --> the minimum fixed rate duration for the right-to-buy-scheme
		- MaxRateDurationRTB --> the maximum fixed rate duration for the right-to-buy-scheme

Note: This version does not allow `owners` to be simultaneously on both the rent and social housing amrket. This behaviour is planned to be added in version 19.0.13.

Version 19.0.10 (YG)

1. Fixed a bug where the interestPerTick for normal buyers was used to update the repayments for first time buyers and BTL buyers (only one of the interestPerTick variables in the function had this issue. So, this bug does not significantly affect the observed trends, but the magnitude of the impact of changing interest rates for FT buyers and BTL buyers on prices is affected).
2. Addressed an issue where `new-repayment` was calculated even if the household has a `mortgage-duration` of 0 - meaning they paid all their mortgage. This led to divisions by 0.

Version 19.0.9 (YG)

1. Added `ageOwnershipWealth` global parameter to monitor the following for each household every tick
	- age
	- number of owned houses
	- wealth
2. Added the ability to force the system to deviate towards a specific ratio of owned houses to all houses
	- `manage-targets` maintains this ratio by (1) forcing mortgage households with a willingness to invest to gain capital and become landlords and (2) forcing owners of one house to evict and become tenants with no capital. This applied over a yearly basis until the year 100 ONLY.
	- `TargetOwnedRatio` slider controls the required ratio of owned houses to all houses
	- `force-target` switch triggers the `manage-targets` function
	- Note: the pupulation dynamics make it significantly difficult to decrease the ratio of owned houses below 50%. This is because giving capital to households who have children increases the probability of triggering the bank-of-mum-and-dad dynamic. That is, more independent children aim to be home-owners, join the mortgage markets and end up competing with investors. With the model prioritising home buyers over investors, this dynamic decreases the probability of landlords acquiring houses. 

Version 19.0.8 (YG)

1. Bugs
	- Addressed an issue where wealth was not set to zero before reevaluating all the owned houses of each owner. This led to overestimating the wealth of landlords, particularly ones owning more than 3 houses.
2. Wealth and capital
	- Wealth is now calculated without considering capital (only considering housing assets)
	- Added a `capital-wealth?` switch
		- on --> consider capital and houses within wealth
		- off --> consider houses ONLY within wealth
3. External landlords
	- Added the functionality for households to own houses in the system while living outside of the system
	- Added an `initial-external-landlords` slider to control the percentage of the rent houses owned by households living outside of the system at initialisation
	- Added an `external-landlords-per-tick` slider to control the percentage of immigrants (new owners) that join the buy-to-let market while living outside of the system
	- Added an `external-landlords` switch to toggle adding external landlords at initialisation and during the runs on and off
4. Rich immigrants
	- Added the functionality to assure a portion of the immigrants are richer that the average. This is used to simulate cases when a forced upgrade in prices can attract richer households (potentially richer than the households currently in the system)
	- Rich immigrants have a higher `capital` and a higher `income` than average
		- `capital` is calculated to cover prices between the median and maximum prices within a defined sample of houses (see `rich-reference` chooser in the next point)
		- `income` is randomly generated between the `MeanIncome` ainput and the maximum `income` of all households
	- Added a `rich-immigrants` slider to control the percentage of the mortgage households entering the system that are rich
	- Added a `rich-reference` chooser
		- "XY modify radius houses" --> considers the houses in the defined modify radius around patch at `patch-x` `patch-y`
		- "All houses" --> considers all the houses in the system

Version 19.0.7 (YG)

1. Bugs
	- Addressed a bug where the parents on the buy-to-let market create children agents (at `independece-age` of the child) on the buy-to-let market by default instead of not on a market. This led to cases where households with `my-house = nobody` would buy a house, offer it for rent and make profit. These households became discouraged later - households with `my-house = nobody` are dealt with as homeless. They are landlords, so when they die they leaving the houses in `my-ownership` with a dead `my-owner` parameter. In some runs, this led to errors if the following happens:
		- a tenant leaves one the dead agent's houses
		- the house is put on the rent market
		- a new tenant makes a successful offer leading to a need to address the `rent-price` of the dead landlord
	- Addressed an issue where in rare cases relatively poor mortgage household that own more than one house may sell their own `my-house` before selling their other `my-ownership`
2. Added the ability to modify prices in particular locations. The following was added:
	- `patch-x` and `patch-y` inputs to indicate the x and y location of the patch around which house prices will be modified
	- `initialPrice` input to change the price of the selected houses at initialistion (i.e., when `ticks = 0`)
	- `mPrice`  input to change the price of the selected houses at `myear`
	- `modify-price-radius` input to indicate the arae around the slected patch in which house prices will be changed
	- `modify-prices` button that changes prices around the selected patch at initialisation and at the `myear`
3. Monitors
	- Addressed an issue where the sale-price graph was showing the mean instead of the median price of the houses (this does not affect the results in the behaviour space experiments)
	- Added `medianSalePriceHouses` and `medianRentPriceHouses` to monitor the medians during the runs and avoid errors in the monitor object
	

Version 19.0.6 (YG)

This version uses a more efficient approach to calculating wealth at the expense of slightly higher memory (ram) usage during the runs. It stores the houses in the locality of each `house` and the relevant records for the valuation of the `house`. The detailed modifications are as follows:

1. House parameters
	- Transformed the `local-realtors` to a list. The order of this list aligns with the order of the `local-sales` and `local-rents` parameters.
	- Added `local-sales` and `local-rents` to store a list of all the relevant sale and rent records for the house when the `valuation` function is called. `local-sales` and `local-rents` include a number of lists of records, each list corresponding to records of a realtor in `local-realtors`. For instance, consider a list of realtors `[Realtor 0 Realtor 1]`, the `local-sales` parameter must be a list including two lists `[ [] [Record 1 Record 2] ]`. In this case, `Realtor 0` has no sale records relevant to this `house` while `Realtor 2` has two records.
	- Added `locality-houses` to store the houses in the `locality` of the `house`.
2. Record paraemters
	- Added `filed-at-houses` as a list corresponding to all the houses at which this record is filed either in `local-sales` or `local-rents`
3. Functions were modified to use the added parameters for a more efficient valuation function execusion. All the function modifications are only executed if `calulcate-wealth?` is set to `true`. Otherwise, the algorithm in version 19.0.4 is used as it is more efficient when wealth is not relevant (due to low number of `valulation` function executions in the first place). The modified functions are:
	- `build-house`
		- The `locality-houses` are identified while constructing houses
		- The houses in the `locality-houses` append the contructed `house` to their own `locality-houses` parameter
	- `demolish-houses`
		- The houses in the `locality-houses` remove the demolished `house` from their own `locality-houses` parameter
	- `file-records`
		- The relevant `record` is added to the `local-sales` and `local-rents` of the houses where the record is. The location of the `record` in the `local-sales` and `local-rents` is dictated based on the `realtor` filing the record.
		- The `nobody` elements in the `local-sales` and `local-rents` are removed when filing. `nobody` is a placeholder for dead records that age beyond their `RealtorMemory`. The `nobody` elements are not removed in the `unfile-records` function as it requires looping through all lists in the lists `local-rents` and `local-sales` for all the houses; and this is computationally demanding. Removing the records in `file-records` embeds it in the executed loop of the houses that will file a record, which leads to periodical cleaning of the lists. The `nobody` values do not cause any errors, but they are taxing in terms of memory so periodic cleaning is sufficient.
		- The `filed-at-houses` of the record stores the houses that updated their `local-sales` or `local-rents`
	- `unfile-records`
		- All the records pointing to the input `house` are removed from the `local-sales` and `local-rents` parameters of the houses in the `filed-at-houses` of the record.
		 

Version 19.0.5 (YG)

1. `file-record` and `unfile-record` transformed to a `global` procedure rather than a `realtor` procedure in alignment with the approach of the added functions to the model

Version 19.0.4 (YG)

1. Children that have not been born or were born before the `owner` entered the system are now added to the `children` list as `nobody` instead of `"placeholder"`. This makes it possible to transform `children` from a list to an agentset.
2. Inheritance
	- `owners` inherit the `capital` of their parent when the parent dies (distributed equally among all the `children` of the `parent`)
	- `owners` inherit the houses in `my-ownership` by selling them and distributing the profit after paying the mortgage
	- Inheritance tax is now calculated on selling a house from my ownership
	- `Inheritance-tax?` switch was added to control whether inheritance tax is applied or not
3. `administrators` breed was added
	- An `administrator` represents a legal administrator responsible for selling a dead parent's houses and distributing the inheritance to the `children`
	- `administrators` clone the parameters `my-ownership`, `mortgage` and `children` from the dying parent
	- An `administrator` becomes the `parent` of each child until the houses are sold and the inheritance is fully distributed
	- An `administrator` updates its `children` parameter when a child `owner` decides to elave the system for any reason. In these cases, the inherited money does not go to the child as it is outside the system (but the child is still counted within the total number of children to assure equal distribution of inheritance)
	- During a sale transaction, if the seller is an `administrator`, it adds to the `capital` of the `children` in the `manage-surplus-seller` function
	- An `administrator` dies and is removed from the `parent` parameter of its `children`
4. Wealth
	- `wealth` parameter was added to owners
	- `wealth` indicates the capital of an owner in addition to the prices of all its houses after deducing the mortgages (For every house in `my-ownership` with a mortgage in `mortgage`, `wealth += capital + sale-price - mortgage`)
	- Added a `calculate-wealth?` switch to give the option of not calculating wealth to save up run time (wealth leads to 3 to 4 times longer runs)
5. Behaviour space
	- Added a set of experiments for wealth and gini at different income levels
	- Added an experiment for testing the impact of inheritance tax after 100 years
	- Added a new baseline scenario with ageing applied

Version 19.0.3 (YG)

1. Bugs
	- Addressed an issue where children households use their parent's `capital` while the parent made an offer on the market (parent `capital` was double counted). This led to cases where children take their parent's `capital` then parent households take higher mortgages than intended due to lower deposits. In these cases, parent households were immediately evicted the next tick due to high mortgage repayments. 

Version 19.0.2 (YG)

1. Owners parameters
	- Added `mortgage-type` to track the type of the mortgage of each house. This allows adding any types of mortgages with their unique LTV and interest rates in the future. It is also necessary to update mortgages and repayments while linking to their `mortgage-type` and any changes in the respective interest rate and LTV.
2. Interest rate
	- Added an `InterestRateFirstTime` representing the interest rate for first-time buyers
	- Added an `InterestRateBTL` representing the interest rate for buy-to-let buyers
3. Aging
	- Added a switch `simulate-aging?` to turn aging on and off
	- Added an `indepent-age` parameter at which children leave their parent's house (by default, independent agents join the rent market unless the inheritence is turned on)
	- Owner agents now give birth at the designated ages
	- Children agents are now generated once they reach their independent age - before this they are added as a `"placeholder"` in their parent's `children` parameter
4. Bank of mum and dad
	- Added a `parent-to-child` parameter representing the percentage of `capital` a parent is willing to provide to its child agent to buy a new `house` 
5. Bugs
	- Addressed a bug at initialisation where mortgage duration and LTV were checked againist different random numbers leading to possibilities where only one considers the agent as a first-time buyer

Version 19.0.1 (YG)

1. Rent to repayment conditions for BTL mortgage
	- Added a `RentToRepayment` slider representing the minimum percentage of the rent of a house from its repayment
	- Included the `RentToRepayment` parameter in the safegaurd check that rent is higher than repayment at initialisation
	- Added a safegaurd check condition for the rent value of a house in the valuation
2. First-time buyers LTV
	- Added a `MaxLoanToValueFirstTime` slider representing the LTV for first-time buyers
	- Added a `FirstTimeBuyersSetup` slider representing the percentage of households initialised as first-time buyers (for mortgage households this addresses whether their current `my-house` was acquired on a first-time buyer LTV or not)
	- Added a `FirstTimeBuyersStep` slider representing the percentage of households entering the system as first-time buyers
3. BTL LTV
	- Added a `MaxLoanToValueBTL` slider representing the LTV for BTL investors
4. Stamp duty
	- Updated stamp duty tax values as per gov.uk on 30-01-2024 (https://www.gov.uk/stamp-duty-land-tax/residential-property-rates)
	- Added control over stamp duty at three levels labelled as `StamDuty-A?`, `StampDuty-B?` and `StampDuty-C?` (the thresholds for each level are described in the interface)
5. Age
	- Added the parameters `age`, `breed-age`, `death-age`, `children` and `parent` for owners
	- Added slider for the minimum, maximum and mean of `age`, `breed-age`, `death-age` and number of `children`
	- Households die at `death-age` (births are not enabled in this version)

Version 18.4 (YG)

1. Added behaviour space for experiments with LTVs and interest rates based on UK data


Version 18.3 (YG)

1. Added a switch labelled "Override-Income-Capital"
	- when turned on, the capital and income of agents is set based on the house prices and rents
2. The prices of houses are based on both the income and capital (capital was not considered in the previous versions)

Version 18.2 (YG)

1. Added a go button allowing for changing LTV during the runs
2. Added a visualisation method through the diversity index based on prices. This is computationally demanding as every step, the diversity index of all the houses must be recalculated.

Version 18.1 (YG)

1. Fixed an issue overriding go nYears at tick number 400
2. Added experiments in the behaviour space to introduce changes at 75 years

Version 18.0 (YG)

1. The following parameters were added to the owners
	- income-surplus --> the residual income for an agent per tick
2. The following input parameters were added
	- CapitalMortgage --> the portion of the total income assigned to a mortgage owner at initialisation
	- CapitalRent --> the portion of the total income assigned to a rent owner at initialisation
3. The savings are taken from the residual income instead of from the total income

Version 17.9 (YG)

1. The following parameters were added to the owners as lists
	- mortgage-initial --> the initially full mortgage agreed to acquire the house
	- mortgage-duration --> the ticks remaining for a mortgage to end
	- rate --> the interest per tick
	- rate-duration --> the remaining ticks before updating the interest per tick
2. The following input parameters were added to the interface
	- MaxRateDurationM --> the maximum duration for fixing interest rate on the "mortgage" market
	- MinRateDurationM --> the minimum duration for fixing interest rate on the "mortgage" market
	- MaxRateDurationBTL --> the maximum duration for fixing interest rate on the "buy-to-let" market
	- MinRateDurationBTL --> the minimum duration for fixing interest rate on the "buy-to-let" market
2. The interest per tick is updated for each house in my-ownership when its respective rate-duration ends
3. The repayments are updated in case of changes in the agreed interest per tick
4. The agreed interest duration is addressed separately for "buy-to-let" and "mortgage" markets
5. Visualisation can now be applied based on types or prices
	- If the VisualiseMode is changed during the run, it is only updated in the next tick
	- The visualisation can be updated without runing the model through the button "update visualisation"
6. Homeless now indicates owners who have been evicted from their houses and are currently on the market looking for a house
7. When making trade offers, owners only consider houses that they can afford in terms of mortgage repayments

Version 17.8 (YG)

1. Added a condition for being well-off for both owners of type "rent" and "mortgage" based on income
2. Addressed an issue that caused setting the "income-rent" of a house with a tenant to 0 during specific transaction conditions
3. Added an "upgrade-tenancy" input parameter representing the ratio of owners of type rent that will upgrade their houses rather than going into a mortgage market
4. Modified the "propensity-threshold" to "investors" so that it represents the portion of investors in the housing market
5. Changed the initialisation process as follows:
	- The owners calculate their maximum repayment based on their income
	- The mortgage is calculated based on the repayment
	- The price is assigned as the mortgage + deposit

This assures the repayments remain within the owners' incomes at initialisation. In the previous versions, initialising with low interest rates allowed owners to borrow more which led to extremely high prices at initialisation. This led to cases where many owners were evicted during the first ticks due to high prices that are associated with high repayments (beyond what the owner's incomes can pay for).

Version 17.7 (YG)

1. Addressed an issue where upshocked renters enterd the "rent" market instead of the "mortgage" market
2. Fixed an issue with "contextualised" mode that led to the generation of owners with myType = 0
3. Added an "nYears" input to control the number of years for a run
4. The following parameters are now of type list (not agentsets):
	- my-ownership
	- mortgage
	- repayment
	- income-rent
5. Not-well-off owners with more than one house now select the house to sell as follows:
	- First, prioritise a house that is not rented, if any (meaning the house does not provide revenue and only adds to the repayment
	- Second, prioritise the house that would yield the highest revenue (i.e. highest SalePrice - Mortgage)
6. Added a "propensity" parameter for owners representing their likelihood to invest into housing (this propensity is randomly generated within [0.0, 1.0] for each owner and remains the same for each owner during the run in this version)
7. Added a "propensity-threshold" slider representing the propensity an owner must exceed to enter the buy-to-let market if they are well off
8. Modified the condition for selling a house if not-well-off; now owners with a house (A) already on the market are not forced to sell another house (B) until house (A) is sold
9. "Inflation" renamed to "WageRise"
10. The house colours are now updated during the ticks to represent their type

Version 17.6 (YG)

1. Added a toggle "ActWhenShocked" to control whether the owners evict or enter the market directly when they experience a downshock or an upshock

Note: Toggling "ActWhenShocked" on leads to a trend of a decreasing number of agents during the 25 year runs (100 ticks). This is due to the assumption that any downshocked agents will either sell one of their my-ownership, or evict if they have no houses to sell further. Toggling "ActWhenShocked" off still keeps the income shock adjustments, and that implicitly leads to evictions or joining markets when checking the financial conditions of the owners in the "manage-market-participation" function.

Version 17.5 (YG KZ)

1. Addressed an issue with low rent prices leading to demolishing rent houses (occurs when a house is bought on a buy-to-let market, put on the rent market and then not having an offer during the tick. This leads to not calling the valuation function, and rent value remains 0)

Version 17.4 (YG)

1. Addressed an issue with reporting the median rent value = 0 in the valuation function
2. Addressed an issue leading to considering a house on the rent market as rented when assigning income-rent to house owners


Version 17.3 (YG)

1. added the first-link to the follow chain function to address rare situations where deep recursions occur


Version 17.2 (YG)

1. addressed an error when a downshocked owner has no more my-ownership that are not for sale. This situation leads the owner to evict and enter the rent market.
2. addressed an error due to not removing my-ownership from the agentset of interesting houses when making offers on a buy-to-let market
3. addressed some cases where landlords did not decrease their income-rent when evicting a tenant
4. addressed some bugs with addressing income-rent during transactions and at the end of each tick
5. added evict-threshold-mortgage and evict-threshold-rent parameters to separately control the eviction conditions for "owners" with myType = rent and myType = mortgage
6. addressed an issue with referring to sale-price instead of rent-price in the valuation function in case of houses with myType = "rent" and for-sale? = true

Version 17.1 (YG)

General modifications at setup

1. Rented houses and renting 'owners' are now added
2. Rented houses now have actual owners (an 'owner' agent that rents the house to another 'owner' agent)
3. Rented houses have their sale price set based on the mortgage and deposit of their owner
4. Owners now get their income increase by the rent amount they receive at setup (this is planned to be modified to add rent every tick, rather than assigning it at the point of creating the agents)
5. The owner's mortgage, capital and repayment are set while considering potential multiple ownerships

General modifications during runs

1. "owner" agents can now join three types of market "mortgage", "rent" and "buy-to-let"
	a. mortgage: joined when tenants have enough money to buy their own house or when a new buyer comes in with the intent of byuing their house
	b. rent: joined when a home owner is not well-off (downshocked) and they own only one house, or when a new tenant comes in the system
	c. buy-to-let: joined when a home owner is well-off (e.g., upshocked) that they can buy another house
2. "house" agents can now be put on the "mortgage" marekt or "rent" market
	a. mortgage: includes all the houses for sale, these can be purchased as a buy-to-let or for a normal mortgage
	b. rent: includes all the houses for rent
	N.B. the owners decide when to put the house on the market based on their budgets. However, any house without an occupier my be put on a market.
3. rents are now added to the "income" of the landlord (to save run time, this is used rather than addressing all landlords every tick to add to their capital from rent separately)


Owners

1. Differenciated between owner and occupier
2. Added my-ownership to owner agents
	a. ownership is an agentset (can be more than one house)
3. Added assign-income-rent
	a. add the rent of my-ownership to the owner's income
4. No longer calculate the mortgage if they are staying on the basis of paying rent
5. No longer calculate rent paid for a mortgage owner
6. added income-rent (separate from normal income)
	a. rent taken from ownership
7. added on-market?
8. added on-market-type
	a. represents the market on which the 'owners' is using to buy/rent (can be "buy-to-let", "mortgage", "rent")	

Houses

1. Added for-rent?
2. Added rent-price
3. added date-for-rent

Records

1. Addded renting prices to the records

Functions

1. manage-market-participation [turtleset of owners]
	- manage evictions --> entering rent market
	- manage well-off --> entering mortgage market
	- This function is a majorly modified version of force-out (force-out is now not used in the model)

2. put-on-market
	- a house function
	- put a house on the market

3. evict [turtleset of owners]
	- remove agents from mortgaged or rented house
	- assure all ownership is also evicted and put on the market

4. force-sell [turtleset of owners]
	- forces the 'owners' to put one of their ownership on the market
	- it is necessary to separate this from the enter-market function as an owner with more than one house can now sell without wanting to buy (i.e., be on the market)

5. enter-market [turtleset + string]
	- put agents on the mortgage or rent market

6. move-houses
	- Significant changes to function to accomodate renting market
	- now assures for the house that myType, my-owner, my-occupier, rented-to are properly addressed

7. assign-income-rent
	- Adds rent at setup to the owners
	- Adds mortgage at setup to the owners
8. manage-surplus
	- Generally addresses the monetary exchange during trade
	- Separate functions are available for each exchange party
9. manage-ownership
	- Generally addresses the house ownership during trade
	- Separate functions are available for each exchange party

Globals

eviction-threshold        --> proportion of (income * Affordability%) that triggers eviction
nEvictedMortgage          --> number of evicted owners of type mortgage
nEvictedRent              --> number of evicted owners of type rent
nEnterMarketMortgage      --> number of owners entering the mortgage market
nEnterMarketRent          --> number of owners entering the rent market
meanIncomeEvictedMortgage --> mean income of evicted owners of type mortgage
meanIncomeEvictedRent     --> mean income of evicted owners of type rent


## Model Structure

1. setup
1.1. build-realtors
1.2. build-owners
__1.2.1. assign-income
__1.2.2. assign-income-rent
1.3. reset-empty-houses
1.4. reset-houses-quality
1.5. reset-realtors
2. Step
2.1. calculate-globals
2.2. shock-management
__2.2.1. put-on-market
2.3. owners-leave
2.4. new-owners
2.5. manage-discouraged
2.6. manage-market-participation
__2.6.1. evict
__2.6.2. enter-market
2.7. new-houses
2.8. trade-house
__2.8.1. value-houses
____2.8.1.1. valuation
__2.8.2. make-offers
____2.8.2.1. make-offer-mortgage
____2.8.2.2. make-offer-rent
__2.8.3. move-house
2.9 remove-outdates
2.10. demolish-houses
2.11. update-prices
2.12. update-owners

## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="241104 Baseline" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>(ticks / TicksPerYear) &gt;= nYears</exitCondition>
    <metric>ifelse-value (any? houses with [myType = "mortgage"]) [count houses with [myType = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? houses with [myType = "rent"]) [count houses with [myType = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [count owners with [mytype = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [count owners with [mytype = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "mortgage" on-market-type]) [count owners with [member? "mortgage" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "rent" on-market-type]) [count owners with [member? "rent" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "buy-to-let" on-market-type]) [count owners with [member? "buy-to-let" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [(mean [income] of owners with [mytype = "mortgage"] + mean [sum income-rent] of owners with [mytype = "mortgage"]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [mean [income] of owners with [mytype = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [(mean [income] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] + mean [sum income-rent] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage"]) [mean [capital] of owners with [myType = "mortgage"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "rent"]) [mean [capital] of owners with [myType = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [mean [capital] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] / 10000] [0]</metric>
    <metric>medianPriceOfHousesForSale</metric>
    <metric>medianSalePriceHouses</metric>
    <metric>medianPriceOfHousesForRent</metric>
    <metric>medianRentPriceRentHouses</metric>
    <metric>ifelse-value (any? owners with [on-market-type = "mortgage" and first-time? = true]) [count owners with [on-market-type = "mortgage" and first-time? = true]] [0]</metric>
    <metric>ifelse-value (any? owners with [first-time? = true]) [count owners with [first-time? = true]] [0]</metric>
    <metric>medianPriceFirstTime</metric>
    <metric>nWealth10k</metric>
    <metric>nWealth10k-50k</metric>
    <metric>nWealth50k-500k</metric>
    <metric>nWealth500k-1m</metric>
    <metric>nWealth1m-2m</metric>
    <metric>nWealth2m-5m</metric>
    <metric>nWealth5m</metric>
    <metric>gini-wealth</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 0]) [count owners with [length my-ownership = 0]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 1]) [count owners with [length my-ownership = 1]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 2]) [count owners with [length my-ownership = 2]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 3]) [count owners with [length my-ownership = 3]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership &gt; 3]) [count owners with [length my-ownership &gt; 3]] [0]</metric>
    <metric>medianSalePriceXYLocality</metric>
    <metric>medianSalePriceXYModifyRadius</metric>
    <metric>medianRentPriceXYLocality</metric>
    <metric>medianRentPriceXYModifyRadius</metric>
    <metric>ageOwnershipWealth</metric>
    <metric>ifelse-value (any? houses with [myType = "social"]) [count houses with [myType = "social"]] [0]</metric>
    <metric>length transactionsRightToBuy</metric>
    <metric>medianPriceRightToBuy</metric>
    <metric>medianPriceOfHousesForRightToBuy</metric>
    <metric>medianRentPriceSocialHouses</metric>
    <metric>medianPriceOfHousesForSocial</metric>
    <metric>length [waiting-list] of public-sector 0</metric>
    <metric>ifelse-value (any? owners with [myType = "social"]) [count owners with [myType = "social"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "right-to-buy" mortgage-type]) [count owners with [member? "right-to-buy" mortgage-type]] [0]</metric>
    <enumeratedValueSet variable="Affordability">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Baseline-type">
      <value value="&quot;1-month step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BuyerSearchLength">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="calculate-wealth?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalMortgage">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalRent">
      <value value="52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalSocial">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capital-wealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clusteringRepeat">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodBTL">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodMortgage">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CycleStrength">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Density">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EntryRate">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-mortgage">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-rent">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-social">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExitRate">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords-per-tick">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersSetup">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersStep">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="force-target">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FullyPaidMortgageOwners">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseConstructionRate">
      <value value="1.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseMeanLifetime">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="income-shock">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndependenceAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Inheritance-tax?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-external-landlords">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InitialGeography">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-max-income-social">
      <value value="32000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialOccupancy">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialPrice">
      <value value="500000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-social-houses">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRate">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateBTL">
      <value value="3.71"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateFirstTime">
      <value value="3.72"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateRTB">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="investors">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Locality">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxBreedAge">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxChildren">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDeathAge">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxHomelessPeriod">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncome">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeFT">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeRTB">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValue">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueBTL">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueFirstTime">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueRTB">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-price-RTB">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationM">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationRTB">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-rent-social">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationFT">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanAge">
      <value value="46"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanBreedAge">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanChildren">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanDeathAge">
      <value value="82"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanIncome">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinBreedAge">
      <value value="22"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinChildren">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinDeathAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInheritance">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-price-fraction">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationM">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationRTB">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterest">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestFT">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestRTB">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-FT">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-RTB">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-BTL">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-FT">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-RTB">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mMaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="modify-price-radius">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-ageOwnershipWealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-xy?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationFirstTime">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mortgage-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mPrice">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTB">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTR">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-A">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-B">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-C">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mYear">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nCouncils">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-owner-type">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-social-houses">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nRealtors">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nYears">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodMortgage">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Override-Income-Capital">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Owned-Rent-Percentage">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ParentToChildCapital">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-x">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-y">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-difference">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PriceDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-social-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-wait-for-RTB-threshold">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorMemory">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorOptimism">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorTerritory">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-difference">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentToRepayment">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-immigrants">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-reference">
      <value value="&quot;All houses&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-to-buy?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-To-Buy-threshold">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTB-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-max-income-social">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Savings">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsRent">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsSocial">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-rent-threshold">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-social-threshold">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="scenario">
      <value value="&quot;base-line&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Shocked">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shock-frequency">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="simulate-aging?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-to-private-rent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-A?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-B?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-C?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TargetOwnedPercent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TicksPerYear">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="upgrade-tenancy">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisualiseMode">
      <value value="&quot;Types&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WageRise">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="241104 LTI_FT_3to6" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go
if (ticks / TicksPerYear) = mYear [
set MaxLoanToIncomeFT mLTI-FT
]</go>
    <exitCondition>(ticks / TicksPerYear) &gt;= nYears</exitCondition>
    <metric>ifelse-value (any? houses with [myType = "mortgage"]) [count houses with [myType = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? houses with [myType = "rent"]) [count houses with [myType = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [count owners with [mytype = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [count owners with [mytype = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "mortgage" on-market-type]) [count owners with [member? "mortgage" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "rent" on-market-type]) [count owners with [member? "rent" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "buy-to-let" on-market-type]) [count owners with [member? "buy-to-let" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [(mean [income] of owners with [mytype = "mortgage"] + mean [sum income-rent] of owners with [mytype = "mortgage"]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [mean [income] of owners with [mytype = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [(mean [income] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] + mean [sum income-rent] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage"]) [mean [capital] of owners with [myType = "mortgage"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "rent"]) [mean [capital] of owners with [myType = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [mean [capital] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] / 10000] [0]</metric>
    <metric>medianPriceOfHousesForSale</metric>
    <metric>medianSalePriceHouses</metric>
    <metric>medianPriceOfHousesForRent</metric>
    <metric>medianRentPriceRentHouses</metric>
    <metric>ifelse-value (any? owners with [on-market-type = "mortgage" and first-time? = true]) [count owners with [on-market-type = "mortgage" and first-time? = true]] [0]</metric>
    <metric>ifelse-value (any? owners with [first-time? = true]) [count owners with [first-time? = true]] [0]</metric>
    <metric>medianPriceFirstTime</metric>
    <metric>nWealth10k</metric>
    <metric>nWealth10k-50k</metric>
    <metric>nWealth50k-500k</metric>
    <metric>nWealth500k-1m</metric>
    <metric>nWealth1m-2m</metric>
    <metric>nWealth2m-5m</metric>
    <metric>nWealth5m</metric>
    <metric>gini-wealth</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 0]) [count owners with [length my-ownership = 0]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 1]) [count owners with [length my-ownership = 1]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 2]) [count owners with [length my-ownership = 2]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 3]) [count owners with [length my-ownership = 3]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership &gt; 3]) [count owners with [length my-ownership &gt; 3]] [0]</metric>
    <metric>medianSalePriceXYLocality</metric>
    <metric>medianSalePriceXYModifyRadius</metric>
    <metric>medianRentPriceXYLocality</metric>
    <metric>medianRentPriceXYModifyRadius</metric>
    <metric>ageOwnershipWealth</metric>
    <metric>ifelse-value (any? houses with [myType = "social"]) [count houses with [myType = "social"]] [0]</metric>
    <metric>length transactionsRightToBuy</metric>
    <metric>medianPriceRightToBuy</metric>
    <metric>medianPriceOfHousesForRightToBuy</metric>
    <metric>medianRentPriceSocialHouses</metric>
    <metric>medianPriceOfHousesForSocial</metric>
    <metric>length [waiting-list] of public-sector 0</metric>
    <metric>ifelse-value (any? owners with [myType = "social"]) [count owners with [myType = "social"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "right-to-buy" mortgage-type]) [count owners with [member? "right-to-buy" mortgage-type]] [0]</metric>
    <enumeratedValueSet variable="Affordability">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Baseline-type">
      <value value="&quot;1-month step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BuyerSearchLength">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="calculate-wealth?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalMortgage">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalRent">
      <value value="52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalSocial">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capital-wealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clusteringRepeat">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodBTL">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodMortgage">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CycleStrength">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Density">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EntryRate">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-mortgage">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-rent">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-social">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExitRate">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords-per-tick">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersSetup">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersStep">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="force-target">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FullyPaidMortgageOwners">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseConstructionRate">
      <value value="1.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseMeanLifetime">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="income-shock">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndependenceAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Inheritance-tax?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-external-landlords">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InitialGeography">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-max-income-social">
      <value value="32000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialOccupancy">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialPrice">
      <value value="500000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-social-houses">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRate">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateBTL">
      <value value="3.71"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateFirstTime">
      <value value="3.72"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateRTB">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="investors">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Locality">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxBreedAge">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxChildren">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDeathAge">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxHomelessPeriod">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncome">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeFT">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeRTB">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValue">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueBTL">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueFirstTime">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueRTB">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-price-RTB">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationM">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationRTB">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-rent-social">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationFT">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanAge">
      <value value="46"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanBreedAge">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanChildren">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanDeathAge">
      <value value="82"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanIncome">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinBreedAge">
      <value value="22"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinChildren">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinDeathAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInheritance">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-price-fraction">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationM">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationRTB">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterest">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestFT">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestRTB">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-FT">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-RTB">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-BTL">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-FT">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-RTB">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mMaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="modify-price-radius">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-ageOwnershipWealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-xy?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationFirstTime">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mortgage-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mPrice">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTB">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTR">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-A">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-B">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-C">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mYear">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nCouncils">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-owner-type">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-social-houses">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nRealtors">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nYears">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodMortgage">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Override-Income-Capital">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Owned-Rent-Percentage">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ParentToChildCapital">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-x">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-y">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-difference">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PriceDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-social-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-wait-for-RTB-threshold">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorMemory">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorOptimism">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorTerritory">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-difference">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentToRepayment">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-immigrants">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-reference">
      <value value="&quot;All houses&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-to-buy?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-To-Buy-threshold">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTB-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-max-income-social">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Savings">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsRent">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsSocial">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-rent-threshold">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-social-threshold">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="scenario">
      <value value="&quot;base-line&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Shocked">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shock-frequency">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="simulate-aging?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-to-private-rent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-A?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-B?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-C?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TargetOwnedPercent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TicksPerYear">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="upgrade-tenancy">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisualiseMode">
      <value value="&quot;Types&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WageRise">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="241104 LTI_all_3to6" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go
if (ticks / TicksPerYear) = mYear [
set MaxLoanToIncome mLTI
set MaxLoanToIncomeFT mLTI-FT
set MaxLoanToIncomeRTB mLTI-RTB
]</go>
    <exitCondition>(ticks / TicksPerYear) &gt;= nYears</exitCondition>
    <metric>ifelse-value (any? houses with [myType = "mortgage"]) [count houses with [myType = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? houses with [myType = "rent"]) [count houses with [myType = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [count owners with [mytype = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [count owners with [mytype = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "mortgage" on-market-type]) [count owners with [member? "mortgage" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "rent" on-market-type]) [count owners with [member? "rent" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "buy-to-let" on-market-type]) [count owners with [member? "buy-to-let" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [(mean [income] of owners with [mytype = "mortgage"] + mean [sum income-rent] of owners with [mytype = "mortgage"]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [mean [income] of owners with [mytype = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [(mean [income] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] + mean [sum income-rent] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage"]) [mean [capital] of owners with [myType = "mortgage"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "rent"]) [mean [capital] of owners with [myType = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [mean [capital] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] / 10000] [0]</metric>
    <metric>medianPriceOfHousesForSale</metric>
    <metric>medianSalePriceHouses</metric>
    <metric>medianPriceOfHousesForRent</metric>
    <metric>medianRentPriceRentHouses</metric>
    <metric>ifelse-value (any? owners with [on-market-type = "mortgage" and first-time? = true]) [count owners with [on-market-type = "mortgage" and first-time? = true]] [0]</metric>
    <metric>ifelse-value (any? owners with [first-time? = true]) [count owners with [first-time? = true]] [0]</metric>
    <metric>medianPriceFirstTime</metric>
    <metric>nWealth10k</metric>
    <metric>nWealth10k-50k</metric>
    <metric>nWealth50k-500k</metric>
    <metric>nWealth500k-1m</metric>
    <metric>nWealth1m-2m</metric>
    <metric>nWealth2m-5m</metric>
    <metric>nWealth5m</metric>
    <metric>gini-wealth</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 0]) [count owners with [length my-ownership = 0]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 1]) [count owners with [length my-ownership = 1]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 2]) [count owners with [length my-ownership = 2]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 3]) [count owners with [length my-ownership = 3]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership &gt; 3]) [count owners with [length my-ownership &gt; 3]] [0]</metric>
    <metric>medianSalePriceXYLocality</metric>
    <metric>medianSalePriceXYModifyRadius</metric>
    <metric>medianRentPriceXYLocality</metric>
    <metric>medianRentPriceXYModifyRadius</metric>
    <metric>ageOwnershipWealth</metric>
    <metric>ifelse-value (any? houses with [myType = "social"]) [count houses with [myType = "social"]] [0]</metric>
    <metric>length transactionsRightToBuy</metric>
    <metric>medianPriceRightToBuy</metric>
    <metric>medianPriceOfHousesForRightToBuy</metric>
    <metric>medianRentPriceSocialHouses</metric>
    <metric>medianPriceOfHousesForSocial</metric>
    <metric>length [waiting-list] of public-sector 0</metric>
    <metric>ifelse-value (any? owners with [myType = "social"]) [count owners with [myType = "social"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "right-to-buy" mortgage-type]) [count owners with [member? "right-to-buy" mortgage-type]] [0]</metric>
    <enumeratedValueSet variable="Affordability">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Baseline-type">
      <value value="&quot;1-month step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BuyerSearchLength">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="calculate-wealth?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalMortgage">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalRent">
      <value value="52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalSocial">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capital-wealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clusteringRepeat">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodBTL">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodMortgage">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CycleStrength">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Density">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EntryRate">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-mortgage">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-rent">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-social">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExitRate">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords-per-tick">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersSetup">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersStep">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="force-target">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FullyPaidMortgageOwners">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseConstructionRate">
      <value value="1.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseMeanLifetime">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="income-shock">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndependenceAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Inheritance-tax?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-external-landlords">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InitialGeography">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-max-income-social">
      <value value="32000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialOccupancy">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialPrice">
      <value value="500000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-social-houses">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRate">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateBTL">
      <value value="3.71"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateFirstTime">
      <value value="3.72"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateRTB">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="investors">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Locality">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxBreedAge">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxChildren">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDeathAge">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxHomelessPeriod">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncome">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeFT">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeRTB">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValue">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueBTL">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueFirstTime">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueRTB">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-price-RTB">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationM">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationRTB">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-rent-social">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationFT">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanAge">
      <value value="46"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanBreedAge">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanChildren">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanDeathAge">
      <value value="82"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanIncome">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinBreedAge">
      <value value="22"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinChildren">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinDeathAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInheritance">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-price-fraction">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationM">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationRTB">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterest">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestFT">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestRTB">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-FT">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-RTB">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-BTL">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-FT">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-RTB">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mMaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="modify-price-radius">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-ageOwnershipWealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-xy?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationFirstTime">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mortgage-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mPrice">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTB">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTR">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-A">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-B">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-C">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mYear">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nCouncils">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-owner-type">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-social-houses">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nRealtors">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nYears">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodMortgage">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Override-Income-Capital">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Owned-Rent-Percentage">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ParentToChildCapital">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-x">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-y">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-difference">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PriceDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-social-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-wait-for-RTB-threshold">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorMemory">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorOptimism">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorTerritory">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-difference">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentToRepayment">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-immigrants">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-reference">
      <value value="&quot;All houses&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-to-buy?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-To-Buy-threshold">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTB-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-max-income-social">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Savings">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsRent">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsSocial">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-rent-threshold">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-social-threshold">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="scenario">
      <value value="&quot;base-line&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Shocked">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shock-frequency">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="simulate-aging?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-to-private-rent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-A?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-B?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-C?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TargetOwnedPercent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TicksPerYear">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="upgrade-tenancy">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisualiseMode">
      <value value="&quot;Types&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WageRise">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="241127 Baseline" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>(ticks / TicksPerYear) &gt;= nYears</exitCondition>
    <metric>ifelse-value (any? houses with [myType = "mortgage"]) [count houses with [myType = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? houses with [myType = "rent"]) [count houses with [myType = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [count owners with [mytype = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [count owners with [mytype = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "mortgage" on-market-type]) [count owners with [member? "mortgage" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "rent" on-market-type]) [count owners with [member? "rent" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "buy-to-let" on-market-type]) [count owners with [member? "buy-to-let" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [(mean [income] of owners with [mytype = "mortgage"] + mean [sum income-rent] of owners with [mytype = "mortgage"]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [mean [income] of owners with [mytype = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [(mean [income] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] + mean [sum income-rent] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage"]) [mean [capital] of owners with [myType = "mortgage"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "rent"]) [mean [capital] of owners with [myType = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [mean [capital] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] / 10000] [0]</metric>
    <metric>medianPriceOfHousesForSale</metric>
    <metric>medianSalePriceHouses</metric>
    <metric>medianPriceOfHousesForRent</metric>
    <metric>medianRentPriceRentHouses</metric>
    <metric>ifelse-value (any? owners with [on-market-type = "mortgage" and first-time? = true]) [count owners with [on-market-type = "mortgage" and first-time? = true]] [0]</metric>
    <metric>ifelse-value (any? owners with [first-time? = true]) [count owners with [first-time? = true]] [0]</metric>
    <metric>medianPriceFirstTime</metric>
    <metric>nWealth10k</metric>
    <metric>nWealth10k-50k</metric>
    <metric>nWealth50k-500k</metric>
    <metric>nWealth500k-1m</metric>
    <metric>nWealth1m-2m</metric>
    <metric>nWealth2m-5m</metric>
    <metric>nWealth5m</metric>
    <metric>gini-wealth</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 0]) [count owners with [length my-ownership = 0]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 1]) [count owners with [length my-ownership = 1]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 2]) [count owners with [length my-ownership = 2]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 3]) [count owners with [length my-ownership = 3]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership &gt; 3]) [count owners with [length my-ownership &gt; 3]] [0]</metric>
    <metric>medianSalePriceXYLocality</metric>
    <metric>medianSalePriceXYModifyRadius</metric>
    <metric>medianRentPriceXYLocality</metric>
    <metric>medianRentPriceXYModifyRadius</metric>
    <metric>ageOwnershipWealth</metric>
    <metric>ifelse-value (any? houses with [myType = "social"]) [count houses with [myType = "social"]] [0]</metric>
    <metric>length transactionsRightToBuy</metric>
    <metric>medianPriceRightToBuy</metric>
    <metric>medianPriceOfHousesForRightToBuy</metric>
    <metric>medianRentPriceSocialHouses</metric>
    <metric>medianPriceOfHousesForSocial</metric>
    <metric>length [waiting-list] of public-sector 0</metric>
    <metric>ifelse-value (any? owners with [myType = "social"]) [count owners with [myType = "social"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "right-to-buy" mortgage-type]) [count owners with [member? "right-to-buy" mortgage-type]] [0]</metric>
    <enumeratedValueSet variable="Affordability">
      <value value="18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Affordability-rent">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Baseline-type">
      <value value="&quot;1-month step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BuyerSearchLength">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="calculate-wealth?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalMortgage">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalRent">
      <value value="52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalSocial">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capital-wealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clusteringRepeat">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodBTL">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodMortgage">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CycleStrength">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Density">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EntryRate">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-mortgage">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-rent">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-social">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExitRate">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords-per-tick">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersSetup">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersStep">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="force-target">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FullyPaidMortgageOwners">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseConstructionRate">
      <value value="1.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseMeanLifetime">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="income-shock">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndependenceAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Inheritance-tax?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-external-landlords">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InitialGeography">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-max-income-social">
      <value value="32000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialOccupancy">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialPrice">
      <value value="500000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-social-houses">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRate">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateBTL">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateFirstTime">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateRTB">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="investors">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Locality">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxBreedAge">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxChildren">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDeathAge">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxForRentPeriodPoorLandlord">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxHomelessPeriod">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncome">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeFT">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeRTB">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValue">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueBTL">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueFirstTime">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueRTB">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-price-RTB">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationM">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationRTB">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-rent-social">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationFT">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanAge">
      <value value="46"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanBreedAge">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanChildren">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanDeathAge">
      <value value="82"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanIncome">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinBreedAge">
      <value value="22"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinChildren">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinDeathAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInheritance">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-price-fraction">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationM">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationRTB">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterest">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestFT">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestRTB">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-FT">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-RTB">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-BTL">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-FT">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-RTB">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mMaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="modify-price-radius">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-ageOwnershipWealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-xy?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationFirstTime">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mortgage-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mPrice">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTB">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTR">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-A">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-B">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-C">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-D">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-Rates">
      <value value="&quot;From 1 April 2025&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mYear">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nCouncils">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-owner-type">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-social-houses">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nRealtors">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nYears">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodMortgage">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Override-Income-Capital">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Owned-Rent-Percentage">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ParentToChildCapital">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-x">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-y">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-difference">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PriceDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-social-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-wait-for-RTB-threshold">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorMemory">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorOptimism">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorTerritory">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-difference">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentToRepayment">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-immigrants">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-reference">
      <value value="&quot;All houses&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-to-buy?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-To-Buy-threshold">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTB-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-max-income-social">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Savings">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsRent">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsSocial">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-rent-threshold">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-social-threshold">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="scenario">
      <value value="&quot;base-line&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Shocked">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shock-frequency">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="simulate-aging?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-to-private-rent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-A?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-B?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-C?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-D?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-Rates">
      <value value="&quot;Up to 31 March 2025&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TargetOwnedPercent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TicksPerYear">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="upgrade-tenancy">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisualiseMode">
      <value value="&quot;Types&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WageRise">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="241127 SD" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go
if (ticks / TicksPerYear) = mYear [
set StampDuty-A? mSD-A
set StampDuty-B? mSD-B
set StampDuty-C? mSD-C
set StampDuty-D? mSD-D
set StampDuty-Rates mSD-Rates
]</go>
    <exitCondition>(ticks / TicksPerYear) &gt;= nYears</exitCondition>
    <metric>ifelse-value (any? houses with [myType = "mortgage"]) [count houses with [myType = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? houses with [myType = "rent"]) [count houses with [myType = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [count owners with [mytype = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [count owners with [mytype = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "mortgage" on-market-type]) [count owners with [member? "mortgage" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "rent" on-market-type]) [count owners with [member? "rent" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "buy-to-let" on-market-type]) [count owners with [member? "buy-to-let" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [(mean [income] of owners with [mytype = "mortgage"] + mean [sum income-rent] of owners with [mytype = "mortgage"]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [mean [income] of owners with [mytype = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [(mean [income] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] + mean [sum income-rent] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage"]) [mean [capital] of owners with [myType = "mortgage"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "rent"]) [mean [capital] of owners with [myType = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [mean [capital] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] / 10000] [0]</metric>
    <metric>medianPriceOfHousesForSale</metric>
    <metric>medianSalePriceHouses</metric>
    <metric>medianPriceOfHousesForRent</metric>
    <metric>medianRentPriceRentHouses</metric>
    <metric>ifelse-value (any? owners with [on-market-type = "mortgage" and first-time? = true]) [count owners with [on-market-type = "mortgage" and first-time? = true]] [0]</metric>
    <metric>ifelse-value (any? owners with [first-time? = true]) [count owners with [first-time? = true]] [0]</metric>
    <metric>medianPriceFirstTime</metric>
    <metric>nWealth10k</metric>
    <metric>nWealth10k-50k</metric>
    <metric>nWealth50k-500k</metric>
    <metric>nWealth500k-1m</metric>
    <metric>nWealth1m-2m</metric>
    <metric>nWealth2m-5m</metric>
    <metric>nWealth5m</metric>
    <metric>gini-wealth</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 0]) [count owners with [length my-ownership = 0]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 1]) [count owners with [length my-ownership = 1]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 2]) [count owners with [length my-ownership = 2]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 3]) [count owners with [length my-ownership = 3]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership &gt; 3]) [count owners with [length my-ownership &gt; 3]] [0]</metric>
    <metric>medianSalePriceXYLocality</metric>
    <metric>medianSalePriceXYModifyRadius</metric>
    <metric>medianRentPriceXYLocality</metric>
    <metric>medianRentPriceXYModifyRadius</metric>
    <metric>ageOwnershipWealth</metric>
    <metric>ifelse-value (any? houses with [myType = "social"]) [count houses with [myType = "social"]] [0]</metric>
    <metric>length transactionsRightToBuy</metric>
    <metric>medianPriceRightToBuy</metric>
    <metric>medianPriceOfHousesForRightToBuy</metric>
    <metric>medianRentPriceSocialHouses</metric>
    <metric>medianPriceOfHousesForSocial</metric>
    <metric>length [waiting-list] of public-sector 0</metric>
    <metric>ifelse-value (any? owners with [myType = "social"]) [count owners with [myType = "social"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "right-to-buy" mortgage-type]) [count owners with [member? "right-to-buy" mortgage-type]] [0]</metric>
    <enumeratedValueSet variable="Affordability">
      <value value="18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Affordability-rent">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Baseline-type">
      <value value="&quot;1-month step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BuyerSearchLength">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="calculate-wealth?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalMortgage">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalRent">
      <value value="52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalSocial">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capital-wealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clusteringRepeat">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodBTL">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodMortgage">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CycleStrength">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Density">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EntryRate">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-mortgage">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-rent">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-social">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExitRate">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords-per-tick">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersSetup">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersStep">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="force-target">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FullyPaidMortgageOwners">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseConstructionRate">
      <value value="1.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseMeanLifetime">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="income-shock">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndependenceAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Inheritance-tax?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-external-landlords">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InitialGeography">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-max-income-social">
      <value value="32000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialOccupancy">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialPrice">
      <value value="500000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-social-houses">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRate">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateBTL">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateFirstTime">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateRTB">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="investors">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Locality">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxBreedAge">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxChildren">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDeathAge">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxForRentPeriodPoorLandlord">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxHomelessPeriod">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncome">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeFT">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeRTB">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValue">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueBTL">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueFirstTime">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueRTB">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-price-RTB">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationM">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationRTB">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-rent-social">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationFT">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanAge">
      <value value="46"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanBreedAge">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanChildren">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanDeathAge">
      <value value="82"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanIncome">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinBreedAge">
      <value value="22"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinChildren">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinDeathAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInheritance">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-price-fraction">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationM">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationRTB">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterest">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestFT">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestRTB">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-FT">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-RTB">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-BTL">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-FT">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-RTB">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mMaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="modify-price-radius">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-ageOwnershipWealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-xy?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationFirstTime">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mortgage-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mPrice">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTB">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTR">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-A">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-B">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-C">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-D">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-Rates">
      <value value="&quot;From 1 April 2025&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mYear">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nCouncils">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-owner-type">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-social-houses">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nRealtors">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nYears">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodMortgage">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Override-Income-Capital">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Owned-Rent-Percentage">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ParentToChildCapital">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-x">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-y">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-difference">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PriceDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-social-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-wait-for-RTB-threshold">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorMemory">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorOptimism">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorTerritory">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-difference">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentToRepayment">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-immigrants">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-reference">
      <value value="&quot;All houses&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-to-buy?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-To-Buy-threshold">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTB-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-max-income-social">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Savings">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsRent">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsSocial">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-rent-threshold">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-social-threshold">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="scenario">
      <value value="&quot;base-line&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Shocked">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shock-frequency">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="simulate-aging?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-to-private-rent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-A?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-B?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-C?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-D?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-Rates">
      <value value="&quot;Up to 31 March 2025&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TargetOwnedPercent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TicksPerYear">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="upgrade-tenancy">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisualiseMode">
      <value value="&quot;Types&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WageRise">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="241127 LTI" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go
if (ticks / TicksPerYear) = mYear [
set MaxLoanToIncome mLTI
set MaxLoanToIncomeFT mLTI-FT
set MaxLoanToIncomeRTB mLTI-RTB
]</go>
    <exitCondition>(ticks / TicksPerYear) &gt;= nYears</exitCondition>
    <metric>ifelse-value (any? houses with [myType = "mortgage"]) [count houses with [myType = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? houses with [myType = "rent"]) [count houses with [myType = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [count owners with [mytype = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [count owners with [mytype = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "mortgage" on-market-type]) [count owners with [member? "mortgage" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "rent" on-market-type]) [count owners with [member? "rent" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "buy-to-let" on-market-type]) [count owners with [member? "buy-to-let" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [(mean [income] of owners with [mytype = "mortgage"] + mean [sum income-rent] of owners with [mytype = "mortgage"]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [mean [income] of owners with [mytype = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [(mean [income] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] + mean [sum income-rent] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage"]) [mean [capital] of owners with [myType = "mortgage"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "rent"]) [mean [capital] of owners with [myType = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [mean [capital] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] / 10000] [0]</metric>
    <metric>medianPriceOfHousesForSale</metric>
    <metric>medianSalePriceHouses</metric>
    <metric>medianPriceOfHousesForRent</metric>
    <metric>medianRentPriceRentHouses</metric>
    <metric>ifelse-value (any? owners with [on-market-type = "mortgage" and first-time? = true]) [count owners with [on-market-type = "mortgage" and first-time? = true]] [0]</metric>
    <metric>ifelse-value (any? owners with [first-time? = true]) [count owners with [first-time? = true]] [0]</metric>
    <metric>medianPriceFirstTime</metric>
    <metric>nWealth10k</metric>
    <metric>nWealth10k-50k</metric>
    <metric>nWealth50k-500k</metric>
    <metric>nWealth500k-1m</metric>
    <metric>nWealth1m-2m</metric>
    <metric>nWealth2m-5m</metric>
    <metric>nWealth5m</metric>
    <metric>gini-wealth</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 0]) [count owners with [length my-ownership = 0]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 1]) [count owners with [length my-ownership = 1]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 2]) [count owners with [length my-ownership = 2]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 3]) [count owners with [length my-ownership = 3]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership &gt; 3]) [count owners with [length my-ownership &gt; 3]] [0]</metric>
    <metric>medianSalePriceXYLocality</metric>
    <metric>medianSalePriceXYModifyRadius</metric>
    <metric>medianRentPriceXYLocality</metric>
    <metric>medianRentPriceXYModifyRadius</metric>
    <metric>ageOwnershipWealth</metric>
    <metric>ifelse-value (any? houses with [myType = "social"]) [count houses with [myType = "social"]] [0]</metric>
    <metric>length transactionsRightToBuy</metric>
    <metric>medianPriceRightToBuy</metric>
    <metric>medianPriceOfHousesForRightToBuy</metric>
    <metric>medianRentPriceSocialHouses</metric>
    <metric>medianPriceOfHousesForSocial</metric>
    <metric>length [waiting-list] of public-sector 0</metric>
    <metric>ifelse-value (any? owners with [myType = "social"]) [count owners with [myType = "social"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "right-to-buy" mortgage-type]) [count owners with [member? "right-to-buy" mortgage-type]] [0]</metric>
    <enumeratedValueSet variable="Affordability">
      <value value="18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Affordability-rent">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Baseline-type">
      <value value="&quot;1-month step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BuyerSearchLength">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="calculate-wealth?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalMortgage">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalRent">
      <value value="52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalSocial">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capital-wealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clusteringRepeat">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodBTL">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodMortgage">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CycleStrength">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Density">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EntryRate">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-mortgage">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-rent">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-social">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExitRate">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords-per-tick">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersSetup">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersStep">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="force-target">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FullyPaidMortgageOwners">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseConstructionRate">
      <value value="1.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseMeanLifetime">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="income-shock">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndependenceAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Inheritance-tax?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-external-landlords">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InitialGeography">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-max-income-social">
      <value value="32000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialOccupancy">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialPrice">
      <value value="500000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-social-houses">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRate">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateBTL">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateFirstTime">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateRTB">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="investors">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Locality">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxBreedAge">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxChildren">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDeathAge">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxForRentPeriodPoorLandlord">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxHomelessPeriod">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncome">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeFT">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeRTB">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValue">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueBTL">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueFirstTime">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueRTB">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-price-RTB">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationM">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationRTB">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-rent-social">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationFT">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanAge">
      <value value="46"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanBreedAge">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanChildren">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanDeathAge">
      <value value="82"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanIncome">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinBreedAge">
      <value value="22"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinChildren">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinDeathAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInheritance">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-price-fraction">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationM">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationRTB">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterest">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestFT">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestRTB">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-FT">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-RTB">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-BTL">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-FT">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-RTB">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mMaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="modify-price-radius">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-ageOwnershipWealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-xy?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationFirstTime">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mortgage-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mPrice">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTB">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTR">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-A">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-B">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-C">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-D">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-Rates">
      <value value="&quot;From 1 April 2025&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mYear">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nCouncils">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-owner-type">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-social-houses">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nRealtors">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nYears">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodMortgage">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Override-Income-Capital">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Owned-Rent-Percentage">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ParentToChildCapital">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-x">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-y">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-difference">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PriceDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-social-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-wait-for-RTB-threshold">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorMemory">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorOptimism">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorTerritory">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-difference">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentToRepayment">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-immigrants">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-reference">
      <value value="&quot;All houses&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-to-buy?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-To-Buy-threshold">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTB-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-max-income-social">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Savings">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsRent">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsSocial">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-rent-threshold">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-social-threshold">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="scenario">
      <value value="&quot;base-line&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Shocked">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shock-frequency">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="simulate-aging?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-to-private-rent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-A?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-B?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-C?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-D?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-Rates">
      <value value="&quot;Up to 31 March 2025&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TargetOwnedPercent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TicksPerYear">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="upgrade-tenancy">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisualiseMode">
      <value value="&quot;Types&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WageRise">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="241127 SD_LTI" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go
if (ticks / TicksPerYear) = mYear [
set StampDuty-A? mSD-A
set StampDuty-B? mSD-B
set StampDuty-C? mSD-C
set StampDuty-D? mSD-D
set StampDuty-Rates mSD-Rates
set MaxLoanToIncomeFT mLTI-FT
]</go>
    <exitCondition>(ticks / TicksPerYear) &gt;= nYears</exitCondition>
    <metric>ifelse-value (any? houses with [myType = "mortgage"]) [count houses with [myType = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? houses with [myType = "rent"]) [count houses with [myType = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [count owners with [mytype = "mortgage"]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [count owners with [mytype = "rent"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "mortgage" on-market-type]) [count owners with [member? "mortgage" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "rent" on-market-type]) [count owners with [member? "rent" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "buy-to-let" on-market-type]) [count owners with [member? "buy-to-let" on-market-type]] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "mortgage"]) [(mean [income] of owners with [mytype = "mortgage"] + mean [sum income-rent] of owners with [mytype = "mortgage"]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [mytype = "rent"]) [mean [income] of owners with [mytype = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [(mean [income] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] + mean [sum income-rent] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage"]) [mean [capital] of owners with [myType = "mortgage"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "rent"]) [mean [capital] of owners with [myType = "rent"] / 10000] [0]</metric>
    <metric>ifelse-value (any? owners with [myType = "mortgage" and propensity &gt; (1 - investors)]) [mean [capital] of owners with [myType = "mortgage" and propensity &gt; (1 - investors)] / 10000] [0]</metric>
    <metric>medianPriceOfHousesForSale</metric>
    <metric>medianSalePriceHouses</metric>
    <metric>medianPriceOfHousesForRent</metric>
    <metric>medianRentPriceRentHouses</metric>
    <metric>ifelse-value (any? owners with [on-market-type = "mortgage" and first-time? = true]) [count owners with [on-market-type = "mortgage" and first-time? = true]] [0]</metric>
    <metric>ifelse-value (any? owners with [first-time? = true]) [count owners with [first-time? = true]] [0]</metric>
    <metric>medianPriceFirstTime</metric>
    <metric>nWealth10k</metric>
    <metric>nWealth10k-50k</metric>
    <metric>nWealth50k-500k</metric>
    <metric>nWealth500k-1m</metric>
    <metric>nWealth1m-2m</metric>
    <metric>nWealth2m-5m</metric>
    <metric>nWealth5m</metric>
    <metric>gini-wealth</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 0]) [count owners with [length my-ownership = 0]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 1]) [count owners with [length my-ownership = 1]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 2]) [count owners with [length my-ownership = 2]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership = 3]) [count owners with [length my-ownership = 3]] [0]</metric>
    <metric>ifelse-value (any? owners with [length my-ownership &gt; 3]) [count owners with [length my-ownership &gt; 3]] [0]</metric>
    <metric>medianSalePriceXYLocality</metric>
    <metric>medianSalePriceXYModifyRadius</metric>
    <metric>medianRentPriceXYLocality</metric>
    <metric>medianRentPriceXYModifyRadius</metric>
    <metric>ageOwnershipWealth</metric>
    <metric>ifelse-value (any? houses with [myType = "social"]) [count houses with [myType = "social"]] [0]</metric>
    <metric>length transactionsRightToBuy</metric>
    <metric>medianPriceRightToBuy</metric>
    <metric>medianPriceOfHousesForRightToBuy</metric>
    <metric>medianRentPriceSocialHouses</metric>
    <metric>medianPriceOfHousesForSocial</metric>
    <metric>length [waiting-list] of public-sector 0</metric>
    <metric>ifelse-value (any? owners with [myType = "social"]) [count owners with [myType = "social"]] [0]</metric>
    <metric>ifelse-value (any? owners with [member? "right-to-buy" mortgage-type]) [count owners with [member? "right-to-buy" mortgage-type]] [0]</metric>
    <enumeratedValueSet variable="Affordability">
      <value value="18"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Affordability-rent">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Baseline-type">
      <value value="&quot;1-month step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BuyerSearchLength">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="calculate-wealth?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalMortgage">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalRent">
      <value value="52"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CapitalSocial">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capital-wealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="clusteringRepeat">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodBTL">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cooldownPeriodMortgage">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CycleStrength">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Density">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EntryRate">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-mortgage">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-rent">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="eviction-threshold-social">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExitRate">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="external-landlords-per-tick">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersSetup">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FirstTimeBuyersStep">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="force-target">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FullyPaidMortgageOwners">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseConstructionRate">
      <value value="1.44"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="HouseMeanLifetime">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="income-shock">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="IndependenceAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Inheritance-tax?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-external-landlords">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InitialGeography">
      <value value="&quot;Random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-max-income-social">
      <value value="32000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialOccupancy">
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initialPrice">
      <value value="500000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-social-houses">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRate">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateBTL">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateFirstTime">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InterestRateRTB">
      <value value="3.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="investors">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Locality">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxBreedAge">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxChildren">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDeathAge">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxForRentPeriodPoorLandlord">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxHomelessPeriod">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncome">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeFT">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToIncomeRTB">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValue">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueBTL">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueFirstTime">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxLoanToValueRTB">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-price-RTB">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationM">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MaxRateDurationRTB">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-rent-social">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationFT">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanAge">
      <value value="46"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanBreedAge">
      <value value="33"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanChildren">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanDeathAge">
      <value value="82"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MeanIncome">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinAge">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinBreedAge">
      <value value="22"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinChildren">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinDeathAge">
      <value value="61"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInheritance">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-price-fraction">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationBTL">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationM">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MinRateDurationRTB">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterest">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestFT">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mInterestRTB">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-FT">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTI-RTB">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-BTL">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-FT">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mLTV-RTB">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mMaxDensity">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="modify-price-radius">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-ageOwnershipWealth?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="monitor-xy?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDuration">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationBTL">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationFirstTime">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="MortgageDurationRTB">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mortgage-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mPrice">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTB">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mRTR">
      <value value="140"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-A">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-B">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-C">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-D">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mSD-Rates">
      <value value="&quot;From 1 April 2025&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mYear">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nCouncils">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-owner-type">
      <value value="&quot;random&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="new-social-houses">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nRealtors">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nYears">
      <value value="400"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodBTL">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="onMarketPeriodMortgage">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Override-Income-Capital">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Owned-Rent-Percentage">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ParentToChildCapital">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-x">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="patch-y">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-difference">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="PriceDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-social-threshold">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="propensity-wait-for-RTB-threshold">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorMemory">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorOptimism">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RealtorTerritory">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-difference">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentDropRate">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rent-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RentToRepayment">
      <value value="120"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-immigrants">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rich-reference">
      <value value="&quot;All houses&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-to-buy?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Right-To-Buy-threshold">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RTB-lag">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-max-income-social">
      <value value="30000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Savings">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsRent">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SavingsSocial">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-rent-threshold">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="savings-to-social-threshold">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="scenario">
      <value value="&quot;base-line&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Shocked">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="shock-frequency">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="simulate-aging?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-lag">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-to-private-rent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-A?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-B?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-C?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-D?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="StampDuty-Rates">
      <value value="&quot;Up to 31 March 2025&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TargetOwnedPercent">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TicksPerYear">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="upgrade-tenancy">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisualiseMode">
      <value value="&quot;Types&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="WageRise">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
