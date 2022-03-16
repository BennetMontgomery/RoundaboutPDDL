(define (problem problem1)
    (:domain roundabout)
    
    ; problem definition for problem 1
    
    (:objects
        r1 r2 r3 r4 r5 r6 - road
        s1 s2 s3 - section
        v1 v2 v3 v4 - car
    )
    
    (:init
        ; section connections. For this problem, there's one roundabout
        (connected s1 s2)
        (connected s2 s3)
        (connected s3 s1)
		(sectionfree s1)
		(sectionfree s2)
		(sectionfree s3)
        
        ; road connections
        (before r2 s1)
        (before r4 s2)      
        (before r6 s3)        
        (after r1 s3)
        (after r3 s1)
        (after r5 s2)          
        
        ; vehicle starting points and speeds
        (atstart v1 r2)        
        (atstart v2 r6)        
        (atstart v3 r6)        
        (atstart v4 r2)        
		(insystem v1)
		(insystem v2)
		(insystem v3)
		(insystem v4)
		
		; vehicle exits
		(exit v1 r5)
		(exit v2 r3)
		(exit v3 r1)
		(exit v4 r1)
		
		; starting speeds
		(= (speed v1) 2)
		(= (speed v2) 1)
		(= (speed v3) 1)
		(= (speed v4) 3)
		
		; starting traffic
		(= (traffic r1) 0)
		(= (traffic r2) 2)
		(= (traffic r3) 0)
		(= (traffic r4) 0)
		(= (traffic r5) 0)
		(= (traffic r6) 2)
		
		; road capacities
		(= (capacity r1) 3)
		(= (capacity r2) 3)
		(= (capacity r3) 3)
		(= (capacity r4) 3)
		(= (capacity r5) 3)
		(= (capacity r6) 3)
		
		; road lengths
		(= (roadlength r1) 6)
		(= (roadlength r2) 6)
		(= (roadlength r3) 8)
		(= (roadlength r4) 8)
		(= (roadlength r5) 6)
		(= (roadlength r6) 10)
    )
    
    (:goal (and 
        (exited v1)
        (exited v2)
        (exited v3)
        (exited v4)))
    
    (:metric minimize (total-time))
)
