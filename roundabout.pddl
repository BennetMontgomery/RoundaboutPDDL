(define (domain roundabout)
    (:requirements :typing :negative-preconditions :durative-actions :fluents)
    
    (:types car road section - object)
    
    (:predicates
        ; how does the road connect to a roundabout?
        ; each roundabout in the system is divided into sections, with every
        ; road intersecting the roundabout at the beginning ('before') or at 
        ; the end ('after') of the section. A road after a section can only be
        ; entered into and a road before a section can only be exited from.
        ; similary, roundabout sections are connected to each other in a one way
        ; route
        (before ?r - road ?s - section)
        (after ?r - road ?s - section)
        (connected ?s1 ?s2 - section)

        ; where does a vehicle enter the system?
        (enter ?c - car ?r - road)
    
        ; where does a vehicle need to exit the system? Has it exited yet?
		(insystem ?c - car)
        (exit ?c - car ?r - road)
		(exited ?c - car)
        
        ; does a roundabout section have a vehicle in it?
        (sectionfree ?s - section)
        
        ; where is a vehicle in the system? A car needs to drive from the start
        ; of a road to the end of that road segment before it can enter the 
        ; roundabout at the end of that road.
        (atstart ?c - car ?r - road)
        (atend ?c - car ?r - road)
        (atsec ?c - car ?s - section)
    )
    
    (:functions
        (speed ?c - car) ; in distance units/time unit
        (roadlength ?r - road) ; in distance units
        ; how many cars can be on a road at the same time?
        (capacity ?r - road)
		; how many cars are in the road right now?
		(traffic ?r - road)
    )
    
    ; action to enter a roundabout in the system
    ; car needs to be on a road entering the specific target roundabout section
    ; and the roundabout needs to have space for the car
    (:durative-action enterRoundabout
        :parameters (?c - car ?s1 ?s2 - section ?r - road)
        :duration (= ?duration 2)
        :condition (and
                        (at start (and 
                            (connected ?s2 ?s1) 
                            (before ?r ?s1)
                            (atend ?c ?r)
                            (sectionfree ?s2)))
                        ; section preceding the section entered needs to remain
                        ; free during turn
                       (over all (sectionfree ?s2)))
        :effect (at end(and
                    	(not (atend ?c ?r))
                    	(atsec ?c ?s1)
                    	(not (sectionfree ?s1))
			(decrease (traffic ?r) 1)))
    )
    
    ; action to exit a roundabout to the road
    ; car needs to be in the section before the exit road
    (:durative-action exitRoundabout
        :parameters (?c - car ?s - section ?r - road)
        :duration (= ?duration 2)
        :condition (and (at start (and (after ?r ?s) (atsec ?c ?s) (< (traffic ?r) (capacity ?r))))
						(over all (< (traffic ?r) (capacity ?r))))
        :effect (at end (and
                    (atstart ?c ?r)
                    (not (atsec ?c ?s))
                    (sectionfree ?s)
					(increase (traffic ?r) 1)))
    )
    
    ; action to move from one roundabout section to the next
    ; car needs to be in one section before it can move to another.
    (:durative-action moveSection
        :parameters (?c - car ?from ?to - section)
        :duration (= ?duration 2)
        :condition (at start (atsec ?c ?from))
        :effect (at end (and
                        (not (atsec ?c ?from))
                        (not (sectionfree ?to))
                        (sectionfree ?from)
                        (atsec ?c ?to)))
    )
    
    ; action to move along a road from start to end. The time that it takes to
    ; do this is governed by vehicle speed 
    (:durative-action drive
        :parameters (?c - car ?r - road)
        :duration (= ?duration (/ (roadlength ?r) (speed ?c)))
        :condition (at start (atstart ?c ?r))
        :effect (at end (atend ?c ?r))
    )
	
	; action to exit from the system upon reaching the goal exit for a vehicle.
	; this prevents a traffic jam in the case where all cars need to exit through
	; the same road.
	(:durative-action exitSystem
		:parameters (?c - car ?r - road)
		:duration (= ?duration 0)
		:condition (at start (and
						(exit ?c ?r)
						(insystem ?c)
						(atend ?c ?r)))
		:effect (at end (and
						(exited ?c)
						(not (insystem ?c))
						(not (atend ?c ?r))
						(decrease (traffic ?r) 1)))
	)
)
