from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Dict

app = FastAPI(title="Vehicle Manufacturer API")

class Manufacturer(BaseModel):
    id: int
    name: str
    country: str

class Vehicle(BaseModel):
    id: int
    manufacturer_id: int
    make: str
    model: str
    year: int

manufacturers: Dict[int, Manufacturer] = {
    1: Manufacturer(id=1, name="Ford", country="USA"),
    2: Manufacturer(id=2, name="Toyota", country="Japan")
}

vehicles: Dict[int, Vehicle] = {
    1: Vehicle(id=1, manufacturer_id=1, make="Ford", model="F-150", year=2023),
    2: Vehicle(id=2, manufacturer_id=2, make="Toyota", model="Camry", year=2024)
}

@app.post("/manufacturers")
def create_manufacturer(manufacturer: Manufacturer):
    if manufacturer.id in manufacturers:
        raise HTTPException(status_code=400, detail="Manufacturer already exists")
    manufacturers[manufacturer.id] = manufacturer
    return manufacturer

@app.get("/manufacturers")
def get_manufacturers():
    return list(manufacturers.values())

@app.get("/manufacturers/{manufacturer_id}")
def get_manufacturer(manufacturer_id: int):
    if manufacturer_id not in manufacturers:
        raise HTTPException(status_code=404, detail="Manufacturer not found")
    return manufacturers[manufacturer_id]

@app.put("/manufacturers/{manufacturer_id}")
def update_manufacturer(manufacturer_id: int, manufacturer: Manufacturer):
    if manufacturer_id not in manufacturers:
        raise HTTPException(status_code=404, detail="Manufacturer not found")
    manufacturers[manufacturer_id] = manufacturer
    return manufacturer

@app.delete("/manufacturers/{manufacturer_id}")
def delete_manufacturer(manufacturer_id: int):
    if manufacturer_id not in manufacturers:
        raise HTTPException(status_code=404, detail="Manufacturer not found")

    del manufacturers[manufacturer_id]
    return {"message": "Manufacturer deleted"}

@app.post("/vehicles")
def create_vehicle(vehicle: Vehicle):
    if vehicle.manufacturer_id not in manufacturers:
        raise HTTPException(status_code=400, detail="Manufacturer does not exist")

    vehicles[vehicle.id] = vehicle
    return vehicle

@app.get("/vehicles")
def get_vehicles():
    return list(vehicles.values())

@app.get("/vehicles/{vehicle_id}")
def get_vehicle(vehicle_id: int):
    if vehicle_id not in vehicles:
        raise HTTPException(status_code=404, detail="Vehicle not found")
    return vehicles[vehicle_id]

@app.put("/vehicles/{vehicle_id}")
def update_vehicle(vehicle_id: int, vehicle: Vehicle):
    if vehicle.manufacturer_id not in manufacturers:
        raise HTTPException(status_code=400, detail="Manufacturer does not exist")

    vehicles[vehicle_id] = vehicle
    return vehicle

@app.delete("/vehicles/{vehicle_id}")
def delete_vehicle(vehicle_id: int):
    if vehicle_id not in vehicles:
        raise HTTPException(status_code=404, detail="Vehicle not found")

    del vehicles[vehicle_id]
    return {"message": "Vehicle deleted"}