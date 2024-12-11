# Elevator Control System Design for Two Elevators  


---

## Overview  
This project involves the design and implementation of a **multi-elevator controller system** using Verilog. The system manages two elevators operating across up to 8 floors, efficiently handling simultaneous user requests while ensuring safety and scalability.

---

## Key Features  
1. **Multi-Elevator Management**  
   - Supports two elevators operating simultaneously across multiple floors.  
   - Handles internal (elevator panel) and external (floor panel) requests concurrently.  

2. **Request Handling**  
   - Queues and prioritizes requests based on direction, proximity, and urgency.  
   - Efficiently differentiates between types of requests to minimize delays.  

3. **State Management**  
   - Operates in distinct states:  
     - `Idle`: Waiting for requests.  
     - `Moving`: Transitioning between floors.  
     - `Doors Open`: Allowing passenger entry/exit.  
     - `Emergency`: Halting due to an emergency trigger.  

4. **Emergency Stop Mechanism**  
   - Stops elevator operations instantly during emergencies.  
   - Resumes normal operations after the emergency state is cleared.  

5. **Door Management**  
   - Doors open/close based on floor requests and timers.  
   - Ensures doors stay open for a specific interval while servicing a floor.  

6. **Priority Handling**  
   - Requests are serviced based on urgency, proximity, and direction.  
   - Reduces overall user wait time and travel distance.  

---

## Design Details  
### Request Handling  
- Requests are tracked as active bits in `requests1` and `requests2`.  
- Maximum (`max_request`) and minimum (`min_request`) requests are calculated for efficient movement logic.  

### Movement Logic  
- Elevators move towards the nearest request or remain idle if none exist.  
- Logical checks prevent overshooting floors.  

### Emergency Stop  
- Dedicated inputs (`emergency_stop1` and `emergency_stop2`) halt elevator operations immediately.  

### Door Mechanism  
- Doors open (`door1` and `door2`) upon arrival at a requested floor and close after a fixed interval controlled by a `door_timer`.  

### Reset Functionality  
- The `reset` signal clears all active states and requests, ensuring a known starting state.  

---

## Performance Metrics  
1. **Clock Efficiency**  
   - Operations synchronized with clock signals ensure deterministic behavior.  
2. **Request Resolution Time**  
   - Proportional to the number and distribution of active requests.  
3. **Emergency Stop Response**  
   - System halts within a single clock cycle during emergencies.  
4. **Idle Efficiency**  
   - Elevators conserve resources when no requests are active.  

---

## Challenges Faced  
- **Concurrent Requests**: Balancing simultaneous operations for two elevators.  
- **Emergency Handling**: Properly resuming operations post-emergency without skipping requests.  
- **Door Timing**: Synchronizing door operations with clock signals and floor arrivals.  
- **Gate Delay**: Addressing propagation delays in combinational logic to prevent glitches.  

---

## Conclusion  
This project demonstrates a **robust elevator control system** that efficiently manages real-world scenarios while prioritizing safety and performance. Future enhancements may include dynamic capacity management and advanced scheduling algorithms for larger-scale buildings.  

---

## Repository Structure  
```plaintext
.
├── src/
│   ├── elevator_control.v      # Main Verilog module
│   ├── testbench.v             # Testbench for simulation
├── docs/
│   ├── report.pdf              # Detailed project report
├── README.md                   # Project README

