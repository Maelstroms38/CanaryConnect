# Canary Connect

## Project Setup

Clone the project repo, open CanaryHomework.xcodeproj and run the project using any iOS device simulator.

## Project Description

Create an app to display a list of home air temperature devices.

## Wireframes

[wireframe.cc](https://wireframe.cc/ny8xle)

## Design Guidelines

- Chose to move temperature display to Device Detail page for scalability.


## API Snippet (List Devices)
```bash
curl -H "Content-Type: application/json"-X GET https://fullstack-challenge-api.herokuapp.com/devices

```
```json
[{"name":"Malory's Bedroom","type":"temperature","value":"73","createdAt":"2018-06-01T18:27:51.699Z","updatedAt":"2018-06-01T18:27:51.699Z","id":"Syg4xfke7"},{"name":"Figgis Agency","type":"humidity","value":"52","createdAt":"2018-06-01T18:28:23.217Z","updatedAt":"2018-06-01T18:28:23.218Z","id":"ByyLef1em"},{"name":"Front Desk","type":"airquality","value":"97","createdAt":"2018-06-01T18:28:57.650Z","updatedAt":"2018-06-01T18:28:57.650Z","id":"rkfOgMJe7"},{"name":"Canary Office","createdAt":"2018-06-07T18:59:02.706Z","updatedAt":"2018-06-07T18:59:02.715Z","id":"Sk1txZvxX"},{"name":"Eric's \\0ffice","createdAt":"2019-09-16T18:28:01.918Z","updatedAt":"2019-09-16T18:28:01.919Z","id":"HyqVV8p8B"}]
```

## MVP Deliverables

- Show devices list with names, types and reading values. 
- Show device details page with max, min, average readings.

- Create unit tests for specific instances:
	- User adds device to list
	- User removes device from list
	- Reading values change: max, min, average

## Post MVP

- Create ability to Add New devices.

## Additional Libraries

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) 
- [StackViewBarChart](https://github.com/haojianzong/StackViewBarChart/tree/master/StackViewBarChartExample)
