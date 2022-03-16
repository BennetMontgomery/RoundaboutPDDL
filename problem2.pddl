(define (problem problem2)
    (:domain roundabout)
    
    ; problem definition for problem 2
    
    (:objects
        r1 r2 r3 r4 r5 r6 - road
        s1 s2 s3 s4 s5 s6 - section
        v1 v2 v3 v4 - car
    )
    
    (:init
        ; section connections. For this problem, there's two roundabouts
        (connected s1 s2)
        (connected s2 s3)
        (connected s3 s1)
        (connected s4 s5)
        (connected s5 s6)
        (connected s6 s4)
        
        ; road connections and lengths
        (before r1 s1)
        (= (roadlength 1 6))
        (after r3 s1)
        (= (roadlength r3 8))
        (before r4 s2)
        (= (roadlength r4 8))
        (after r5 s2)
        (= (roadlength r5 6))
        (before r6 s3)
        (= (roadlength r6 10))
        (after r1 s3)
        (= (roadlength r1 6))
        
        ; vehicle starting points and speeds
        (atstart v1 r2)
        (= (speed v1 2))
        (atstart v2 r6)
        (= (speed v2 1))
        (atstart v3 r6)
        (= (speed v3 1))
        (atstart v4 r2)
        (= (speed 3))
    )
    
    (:goal (and 
        (atend v1 r5)
        (atend v2 r3)
        (atend v3 r1)
        (atend v4 r1)))

    (:metric minimize (total-time))
)