# Ecodrive-Drive-Green-Live-Clean-

# EcoDrive Rewards - DriveGreen LiveClean

EcoDrive Rewards is a platform that calculates carbon emissions based on travel distance and vehicle type. Users earn tokens for reducing emissions and can redeem them for rewards.

---

## **Prerequisites**
Make sure you have the following installed on your system:
- **Node.js** (v22.14.0 or later)
- **MATLAB** (R2024b or later)
- **SQLite** (included in the project)

---

## **Installation and Setup**

### **1. Clone the Repository**
```bash
git clone https://github.com/your-repo/ecodrive.git
cd ecodrive
```

### **2. Install Dependencies**
```bash
npm install
```

### **3. Start the Backend Server**
```bash
cd server
node server.js
```
**Expected Output:**
```
Database initialized successfully
Server running at http://localhost:3000
Test endpoint: http://localhost:3000/api/login
```

### **4. Start MATLAB and Verify Installation**
Run the following command in your terminal to check MATLAB installation:
```bash
matlab -batch "disp('MATLAB works')"
```
If MATLAB is working correctly, you should see the output:
```
MATLAB works
```

### **5. Open the Frontend (index.html)**
- Open `index.html` in your browser to interact with the application.

---

## **API Endpoints**

### **1. User Authentication**
- **Login:** `POST /api/login`
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```

- **Signup:** `POST /api/signup`
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com",
    "password": "securepassword"
  }
  ```

### **2. Carbon Footprint Calculation**
- **Calculate Emissions:** `POST /api/calculate`
  ```json
  {
    "distance": 50,
    "vehicle": "car",
    "email": "user@example.com"
  }
  ```

- **Redeem Tokens:** `POST /api/redeem`
  ```json
  {
    "cost": 100,
    "email": "user@example.com"
  }
  ```

---

## **Troubleshooting**
- **Issue: MATLAB is not recognized**
  - Ensure MATLAB is added to your system PATH.
  - Run MATLAB manually using `matlab -batch "disp('MATLAB works')"`.
  
- **Issue: Server crashes on startup**
  - Ensure you installed all dependencies using `npm install`.
  - Check if `server/database.js` is correctly configured.

---

## **Future Improvements**
- Implement leaderboard to encourage eco-friendly travel.
- Add more vehicle types for better accuracy.
- Improve UI and reward options.

---

## **License**
This project is open-source and available under the [MIT License](LICENSE).
