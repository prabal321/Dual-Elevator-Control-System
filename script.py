import math

# Constants for gate complexities and delays (in nanoseconds)
AND_GATE_DELAY = 1  # ns
OR_GATE_DELAY = 1   # ns
NOT_GATE_DELAY = 0.5  # ns
MUX_DELAY = 2  # ns for each 2:1 MUX
FLIP_FLOP_DELAY = 3  # ns

AND_GATE_COUNT = 2  # Per AND operation
OR_GATE_COUNT = 2   # Per OR operation
NOT_GATE_COUNT = 1  # Per NOT operation
MUX_GATE_COUNT = 6  # Per 2:1 MUX
FLIP_FLOP_COUNT = 12  # Per Flip-Flop

# Function to calculate the gate count and delay for a single elevator
def calculate_elevator_gates_and_delay():
    # Approximating gates which are used for the request handling 
    num_floors = 8  # 3-bit floors
    request_gates = num_floors * (AND_GATE_COUNT + OR_GATE_COUNT + NOT_GATE_COUNT)

    # Max/min calculation
    max_min_gates = num_floors * AND_GATE_COUNT  

    # Door control logic gates
    door_control_gates = 4 * AND_GATE_COUNT + 2 * OR_GATE_COUNT  

    # State control (idle, moving, doors open)
    state_control_gates = 3 * AND_GATE_COUNT + 2 * OR_GATE_COUNT + NOT_GATE_COUNT

    # Total gates
    total_gates = request_gates + max_min_gates + door_control_gates + state_control_gates
    total_gates += num_floors * FLIP_FLOP_COUNT  # Add flip-flops as state storage element

    # Delay estimation 
    max_delay = (num_floors * OR_GATE_DELAY) + state_control_gates * AND_GATE_DELAY

    return total_gates, max_delay

# Function to calculate delay for both elevators
def calculate_dual_lift():
    gates1, delay1 = calculate_elevator_gates_and_delay()
    gates2, delay2 = calculate_elevator_gates_and_delay()

    # Sum for 2-lift system
    total_gates = gates1 + gates2
    max_delay = max(delay1, delay2)  # Lifts are working simultaneously

    return total_gates, max_delay

if __name__ == "__main__":  # Correct condition to check if script is executed directly
    total_gates, max_delay = calculate_dual_lift()
    print("=== Dual Elevator Controller Design Analysis ===")
    print(f"Total Gate Count: {total_gates} gates")
    print(f"Estimated Maximum Delay: {max_delay:.2f} ns")
