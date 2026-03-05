// Reloj Vintage Digital 2.0 - Script Completo
class VintageClockSystem {
    constructor() {
        this.currentCity = 'America/Argentina/Buenos_Aires';
        this.cities = {
            'America/Argentina/Buenos_Aires': 'Buenos Aires',
            'America/New_York': 'New York',
            'Europe/London': 'London',
            'Asia/Tokyo': 'Tokyo',
            'Australia/Sydney': 'Sydney',
            'America/Sao_Paulo': 'São Paulo',
            'Europe/Madrid': 'Madrid',
            'America/Mexico_City': 'Mexico City',
            'Asia/Dubai': 'Dubai',
            'Europe/Moscow': 'Moscow',
            'America/Los_Angeles': 'Los Angeles',
            'Asia/Shanghai': 'Shanghai',
            'Europe/Paris': 'Paris',
            'Asia/Kolkata': 'Mumbai',
            'Australia/Perth': 'Perth',
            'America/Chicago': 'Chicago',
            'Asia/Singapore': 'Singapore',
            'Africa/Cairo': 'Cairo',
            'Europe/Berlin': 'Berlin',
            'America/Toronto': 'Toronto',
            'Asia/Hong_Kong': 'Hong Kong',
            'America/Santiago': 'Santiago',
            'Asia/Seoul': 'Seoul'
        };
        
        this.init();
        this.startAnalogClock();
    }

    init() {
        this.populateCitySelector();
        this.setupEventListeners();
        this.updateAllClocks();
        this.startDigitalClock();
    }

    populateCitySelector() {
        const select = document.getElementById('city-select');
        Object.entries(this.cities).forEach(([tz, name]) => {
            const option = document.createElement('option');
            option.value = tz;
            option.textContent = name;
            if (tz === this.currentCity) {
                option.selected = true;
            }
            select.appendChild(option);
        });
    }

    setupEventListeners() {
        document.getElementById('city-select').addEventListener('change', (e) => {
            this.currentCity = e.target.value;
            this.updateAllClocks();
        });
    }

    getCurrentTime() {
        const now = new Date();
        const formatter = new Intl.DateTimeFormat('en-US', {
            timeZone: this.currentCity,
            hour12: false,
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
        const parts = formatter.formatToParts(now);
        const time = {};
        parts.forEach(({ type, value }) => {
            time[type] = value;
        });
        return time;
    }

    updateAllClocks() {
        this.updateDigitalClock();
        this.updateInfo();
    }

    updateDigitalClock() {
        const time = this.getCurrentTime();
        document.getElementById('hour1').textContent = time.hour[0];
        document.getElementById('hour2').textContent = time.hour[1];
        document.getElementById('minute1').textContent = time.minute[0];
        document.getElementById('minute2').textContent = time.minute[1];
        document.getElementById('second1').textContent = time.second[0];
        document.getElementById('second2').textContent = time.second[1];
    }

    updateInfo() {
        const now = new Date();
        const formatter = new Intl.DateTimeFormat('es-AR', {
            timeZone: this.currentCity,
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
        
        const parts = formatter.formatToParts(now);
        const info = {
            date: '',
            timezone: '',
            day: ''
        };

        // Extraer componentes de la fecha extendida
        let weekdays = parts.filter(p => p.type === 'weekday').map(p => p.value);
        let months = parts.filter(p => p.type === 'month').map(p => p.value);
        let days = parts.filter(p => p.type === 'day').map(p => p.value);
        
        if (weekdays.length > 0) {
            info.day = weekdays[0];
        }
        if (months.length > 0 && days.length > 0) {
            info.date = `${days[0]} ${months[0]}`.toUpperCase();
        }
        info.timezone = this.cities[this.currentCity] || this.currentCity.split('/').pop().replace('_', ' ');

        document.getElementById('date').textContent = info.date;
        document.getElementById('timezone').textContent = info.timezone;
        document.getElementById('day').textContent = info.day;
    }

    // Reloj analógico
    startAnalogClock() {
        const analogElement = document.getElementById('analog-clock');
        this.drawMarkers(analogElement);
        this.drawHands(analogElement);
        
        setInterval(() => {
            this.updateAnalogClock();
        }, 1000);
    }

    drawMarkers(clock) {
        // Números
        for (let i = 1; i <= 12; i++) {
            const num = document.createElement('div');
            num.className = 'number';
            num.textContent = i;
            
            const angle = ((i - 3) * 30) * (Math.PI / 180);
            const x = 50 + 40 * Math.cos(angle);
            const y = 50 + 40 * Math.sin(angle);
            num.style.left = x + '%';
            num.style.top = y + '%';
            num.style.transform = 'translate(-50%, -50%)';
            
            clock.appendChild(num);
        }

        // Puntos para minutas
        for (let i = 0; i < 60; i++) {
            const marker = document.createElement('div');
            marker.className = i % 5 === 0 ? 'marker major' : 'marker';
            
            const angle = (i - 15) * 6 * (Math.PI / 180);
            const x = 50 + 45 * Math.cos(angle);
            const y = 50 + 45 * Math.sin(angle);
            const x2 = 50 + 48 * Math.cos(angle);
            const y2 = 50 + 48 * Math.sin(angle);
            
            marker.style.position = 'absolute';
            marker.style.left = x + '%';
            marker.style.top = y + '%';
            marker.style.width = '2px';
            marker.style.height = i % 5 === 0 ? '6%' : '3%';
            marker.style.background = i % 5 === 0 ? '#fff' : var(--cyber-secondary);
            marker.style.transformOrigin = '50% 50%';
            marker.style.transform = `translate(-50%, -50%) rotate(${angle + 90}rad)`;
            
            clock.appendChild(marker);
        }
    }

    drawHands(clock) {
        // Crear agujas
        ['hour', 'minute', 'second'].forEach(type => {
            const hand = document.createElement('div');
            hand.id = `hand-${type}`;
            hand.className = `hand ${type}`;
            hand.style.position = 'absolute';
            hand.style.bottom = '50%';
            hand.style.left = '50%';
            hand.style.transformOrigin = 'bottom center';
            hand.style.borderRadius = '50%';
            clock.appendChild(hand);
        });

        this.styleHands();
    }

    styleHands() {
        const hourHand = document.getElementById('hand-hour');
        const minuteHand = document.getElementById('hand-minute');
        const secondHand = document.getElementById('hand-second');

        hourHand.style.width = '8px';
        hourHand.style.height = '25%';
        hourHand.style.background = 'linear-gradient(90deg, var(--cyber-primary), var(--cyber-secondary))';
        hourHand.style.boxShadow = '0 0 20px var(--cyber-primary)';

        minuteHand.style.width = '6px';
        minuteHand.style.height = '35%';
        minuteHand.style.background = 'linear-gradient(90deg, var(--cyber-secondary), var(--cyber-accent))';
        minuteHand.style.boxShadow = '0 0 15px var(--cyber-secondary)';

        secondHand.style.width = '3px';
        secondHand.style.height = '40%';
        secondHand.style.background = 'var(--cyber-accent)';
        secondHand.style.boxShadow = '0 0 20px var(--