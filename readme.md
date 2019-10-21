# Canary Connect

## Project Setup

Clone the project repo, open CanaryHomework.xcodeproj and run the project using any iOS device simulator. 

Unit tests can be run by visiting the "CanaryHomeworkTests" build scheme and selecting any individual test.

## Project Description

Create an app to display a list of home air temperature devices.

## Wireframes

[wireframe.cc](https://wireframe.cc/ny8xle)

## Design Decisions

- The original design includes a secondary label on the devices list screen. I chose to remove this due to the need for extra requests to get device readings.  

- The detail pages includes UISegmentedControl to determine the type of reading displayed. I think this provides a simpler interface, for those looking for detailed temperature information.

## Deliverables

- Show devices list with names, types and reading values. 
- Show device details page with max, min, average readings.

- Create unit tests for specific instances:
	- Reading devices list from sample JSON
	- Reading devices name from sample JSON

## Additional Libraries

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) 

## API Snippet (List Devices)
```bash
curl -H "Content-Type: application/json"-X GET https://fullstack-challenge-api.herokuapp.com/devices

```
```json
[{"name":"Malory's Bedroom","type":"temperature","value":"73","createdAt":"2018-06-01T18:27:51.699Z","updatedAt":"2018-06-01T18:27:51.699Z","id":"Syg4xfke7"},{"name":"Figgis Agency","type":"humidity","value":"52","createdAt":"2018-06-01T18:28:23.217Z","updatedAt":"2018-06-01T18:28:23.218Z","id":"ByyLef1em"},{"name":"Front Desk","type":"airquality","value":"97","createdAt":"2018-06-01T18:28:57.650Z","updatedAt":"2018-06-01T18:28:57.650Z","id":"rkfOgMJe7"},{"name":"Canary Office","createdAt":"2018-06-07T18:59:02.706Z","updatedAt":"2018-06-07T18:59:02.715Z","id":"Sk1txZvxX"},{"name":"Eric's \\0ffice","createdAt":"2019-09-16T18:28:01.918Z","updatedAt":"2019-09-16T18:28:01.919Z","id":"HyqVV8p8B"}]
```
