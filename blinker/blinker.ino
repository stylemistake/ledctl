const int LED_R = 11;
const int LED_G = 12;
const int LED_B = 13;

int ch;

void setup() {
    
    // initialize serial communication:
    Serial.begin( 9600 );
    
    // initialize the LED pin as an output:
    pinMode( LED_R, OUTPUT );
    pinMode( LED_G, OUTPUT );
    pinMode( LED_B, OUTPUT );
    
}

// Play tone when LED lights up
void playTone( int freq ) {
    tone( 8, freq, 20 );
    if ( Serial.available() == 0 ) {
        delay( 20 );
        noTone( 8 );
    }
}

void loop() {
  
    // see if there's incoming serial data:
    if ( Serial.available() > 0 ) {
      
        ch = Serial.read();
        
        switch ( ch ) {
            case 'R':
                digitalWrite( LED_R, HIGH );
                playTone( 2000 );
                break;
            case 'r':
                digitalWrite( LED_R, LOW  );
                break;
            case 'G':
                digitalWrite( LED_G, HIGH );
                playTone( 3000 );
                break;
            case 'g':
                digitalWrite( LED_G, LOW  );
                break;
            case 'B':
                digitalWrite( LED_B, HIGH );
                playTone( 3500 );
                break;
            case 'b':
                digitalWrite( LED_B, LOW  );
                break;
        }

    }
}

