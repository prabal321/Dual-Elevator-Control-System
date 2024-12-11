import math

AND_GATE_DELAY = 1  
OR_GATE_DELAY = 1   
NOT_GATE_DELAY = 0.5  
MUX_DELAY = 2  
FLIP_FLOP_DELAY = 3  

AND_GATE_COUNT = 2  
OR_GATE_COUNT = 2   
NOT_GATE_COUNT = 1  
MUX_GATE_COUNT = 6  
FLIP_FLOP_COUNT = 12  

def calculate_elevator_gates_and_delay():
    num_floors = 8  
    request_gates = num_floors * (AND_GATE_COUNT + OR_GATE_COUNT + NOT_GATE_COUNT)

    max_min_gates = num_floors * AND_GATE_COUNT  

    door_control_gates = 4 * AND_GATE_COUNT + 2 * OR_GATE_COUNT  

    state_control_gates = 3 * AND_GATE_COUNT + 2 * OR_GATE_COUNT + NOT_GATE_COUNT

    total_gates = request_gates + max_min_gates + door_control_gates + state_control_gates
    total_gates += num_floors * FLIP_FLOP_COUNT  
    
    max_delay = (num_floors * OR_GATE_DELAY) + state_control_gates * AND_GATE_DELAY

    return total_gates, max_delay

def calculate_dual_lift():
    gates1, delay1 = calculate_elevator_gates_and_delay()
    gates2, delay2 = calculate_elevator_gates_and_delay()

    total_gates = gates1 + gates2
    max_delay = max(delay1, delay2)  

    return total_gates, max_delay

if __name__ == "__main__":  
    total_gates, max_delay = calculate_dual_lift()
    print("=== Dual Elevator Controller Design Analysis ===")
    print(f"Total Gate Count: {total_gates} gates")
    print(f"Estimated Maximum Delay: {max_delay:.2f} ns")
