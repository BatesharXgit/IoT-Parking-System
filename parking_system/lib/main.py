import machine
import utime
import network
import urequests

# Wi-Fi credentials
SSID = 'realme'
PASSWORD = '12345678'

# Firebase configuration
FIREBASE_URL = "https://parking-system-49d7c-default-rtdb.firebaseio.com/sensor_data.json"
BOOKING_URL = "https://parking-system-49d7c-default-rtdb.firebaseio.com/booking_status.json"

# Defining the servo pins
servo_pin1 = machine.Pin(17)  # Servo motor for gate opening
servo_pin2 = machine.Pin(18)  # Servo motor for gate closing

# Defining the IR sensor pins
ir_sensor_pin1 = machine.Pin(16)  # IR sensor 1 for gate opening
ir_sensor_pin2 = machine.Pin(19)  # IR sensor 2 for gate closing
ir_sensor_pin3 = machine.Pin(14)  # IR sensor for Slot 1
ir_sensor_pin4 = machine.Pin(15)  # IR sensor for Slot 2
ir_sensor_pin5 = machine.Pin(13)  # IR sensor for Slot 3

# Slot names
slot_names = ["Slot 1", "Slot 2", "Slot 3"]

# Creating a PWM object for the servo motors
m1 = machine.PWM(servo_pin1)
m2 = machine.PWM(servo_pin2)
m1.freq(50)
m2.freq(50)

# Function to connect to Wi-Fi
def connect_wifi(ssid, password):
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect(ssid, password)
    
    while not wlan.isconnected():
        print('Connecting to Wi-Fi...')
        utime.sleep(1)
    
    print('Connected to Wi-Fi:', wlan.ifconfig())

# Function to update Firebase
def update_firebase(data):
    try:
        response = urequests.put(FIREBASE_URL, json=data)
        response.close()
    except Exception as e:
        print("Error updating Firebase:", e)

# Function to get booking status from Firebase with retries
def get_booking_status(retries=3, delay=5):
    for attempt in range(retries):
        try:
            response = urequests.get(BOOKING_URL)
            if response.status_code == 200:
                status = response.json()
                response.close()
                print("Booking status fetched:", status)
                ir3_booked = status.get("Slot 1", {}).get("booked", 0)
                ir4_booked = status.get("Slot 2", {}).get("booked", 0)
                ir5_booked = status.get("Slot 3", {}).get("booked", 0)
                return ir3_booked, ir4_booked, ir5_booked
            else:
                print("Error fetching booking status. Status code:", response.status_code)
                response.close()
        except Exception as e:
            print(f"Error fetching booking status (attempt {attempt + 1}):", e)
            utime.sleep(delay)
    return 0, 0, 0

# Check Wi-Fi connection
connect_wifi(SSID, PASSWORD)

# Test connection to Firebase
try:
    print("Testing Firebase connection...")
    test_response = urequests.get(FIREBASE_URL)
    if test_response.status_code == 200:
        print("Firebase connection successful!")
    else:
        print("Firebase connection failed with status code:", test_response.status_code)
    test_response.close()
except Exception as e:
    print("Error testing Firebase connection:", e)

try:
    while True:
        # Get booking status
        ir3_booked, ir4_booked, ir5_booked = get_booking_status()
        
        # Convert booking status to boolean (1 or 0 to True or False)
        ir3_booked = bool(ir3_booked)
        ir4_booked = bool(ir4_booked)
        ir5_booked = bool(ir5_booked)
        
        # Check IR sensors for vehicle presence
        ir1_value = ir_sensor_pin1.value()
        ir2_value = ir_sensor_pin2.value()
        ir3_value = ir_sensor_pin3.value()
        ir4_value = ir_sensor_pin4.value()
        ir5_value = ir_sensor_pin5.value()
        
        # Debugging output
        print("IR Sensor Values before override:")
        print(f"ir1: {ir1_value}, ir2: {ir2_value}, ir3: {ir3_value}, ir4: {ir4_value}, ir5: {ir5_value}")
        
        # Override IR sensor values if slots are booked
        ir3_value = ir3_booked or ir3_value
        ir4_value = ir4_booked or ir4_value
        ir5_value = ir5_booked or ir5_value
        
        print("IR Sensor Values after override:")
        print(f"ir3: {ir3_value}, ir4: {ir4_value}, ir5: {ir5_value}")
        
        # Open gate if a vehicle is detected and slots are available
        if ir1_value == 0:
            # Rotate servo 1 (gate opening)
            for duty_cycle in range(4800, 500, -10):  # Adjusted from 4800 to 500
                m2.duty_u16(duty_cycle)  # Using duty_u16 to set duty cycle
                utime.sleep_ms(5)
            utime.sleep(2)
            for duty_cycle in range(500, 4800, 10):  # Adjusted from 500 to 4800
                m2.duty_u16(duty_cycle)  # Using duty_u16 to set duty cycle
                utime.sleep_ms(5)
            m2.duty_u16(0)  # Stop servo
        else:
            m2.duty_u16(0)  # Stop servo
        
        # Close gate if no vehicle is detected
        if ir2_value == 0:
            # Rotate servo 2 (gate closing)
            for duty_cycle in range(4800, 500, -10):  # Adjusted from 4800 to 500
                m1.duty_u16(duty_cycle)  # Using duty_u16 to set duty cycle
                utime.sleep_ms(5)
            utime.sleep(2)
            for duty_cycle in range(500, 4800, 10):  # Adjusted from 500 to 4800
                m1.duty_u16(duty_cycle)  # Using duty_u16 to set duty cycle
                utime.sleep_ms(5)
            m1.duty_u16(0)  # Stop servo
        else:
            m1.duty_u16(0)  # Stop servo
        
        # Prepare data for all slots
        timestamp_str = '{}-{:02d}-{:02d} {:02d}:{:02d}:{:02d}'.format(*utime.localtime()[:6])
        sensor_data = {
            "Slot 1": {"sensor_id": "Slot 1", "value": ir3_value, "timestamp": timestamp_str},
            "Slot 2": {"sensor_id": "Slot 2", "value": ir4_value, "timestamp": timestamp_str},
            "Slot 3": {"sensor_id": "Slot 3", "value": ir5_value, "timestamp": timestamp_str}
        }
        
        # Update Firebase with sensor data for all slots
        update_firebase(sensor_data)
        print("Updated Firebase:", sensor_data)

        # Pause before next iteration
        utime.sleep(1)

finally:
    # Clean up by turning off the PWM signal
    m1.duty_u16(0)
    m2.duty_u16(0)
    m1.deinit()
    m2.deinit()

