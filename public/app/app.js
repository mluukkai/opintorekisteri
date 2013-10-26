var app = angular.module('app', []);

app.config(
    function Conf($routeProvider) {
        $routeProvider.
            when('/groups', {
                controller:"GroupsController",
                templateUrl:'app/views/groups.html'
            }).
            when('/group/:id', {
                controller:"GroupController",
                templateUrl:'app/views/group.html'
            }).
            when('/graph/:id/:year/:order', {
                controller:"GraphController",
                templateUrl:'app/views/graph.html'
            }).
            otherwise({
                redirectTo:'/groups'
            });
    }
);

app.directive("spinner", function(){
    return {
        restrict: "E",
        templateUrl: "app/templates/spinner.html"
    }
});

app.controller("GroupsController", function ($scope, $http) {

    $http.get('api/groups').
        success(function (data, status, headers, config) {
            $scope.groups = data;
        });

});

app.controller("GroupController", function ($scope, $http, $routeParams) {
    $scope.ready = false;

    $http.get('api/groups/' + $routeParams.id).
        success(function (data, status, headers, config) {
            $scope.group = data.group;

            $scope.year = data.group.start_year;

            $scope.years = data.years;

            var keys = [];
            for (var k in data.years[0]) {
                keys.push(k);
            }
            $scope.keys = keys;

            $scope.ready = true;
        });
});

app.controller("GraphController", function ($scope, $http, $routeParams) {
    $scope.ready = false;
    $scope.id = $routeParams.id;
    $scope.year = $routeParams.year;

    $scope.selectHandler = function(){
        var selectedItem = $scope.chart.getSelection()[0];
        if (selectedItem) {
            var i = $scope.data.getValue(selectedItem.row, 0);
            $scope.student = $scope.map[i];
            $scope.$apply();

            $http.get('api/student/' + $scope.map[i]).
                success(function (data, status, headers, config) {
                    $scope.student = data;
                });
        }
    }

    $http.get('api/groups/'+$routeParams.id+'/'+$routeParams.year+'/'+$routeParams.order).
        success(function (data, status, headers, config) {
            $scope.plot = data.plot;

            $scope.title = data.group.name;
            $scope.order = $routeParams.order;

            console.log(data.group.start_year.class);

            $scope.years = [];

            for(var y=data.group.start_year; y<2013; y++) {
                $scope.years.push(y);
            }

            var plot = [];
            angular.forEach(data.plot, function (e) {
                plot.push([e[0], e[1]]);
            });

            $scope.map = {};
            angular.forEach(data.plot, function (e) {
                $scope.map[e[0]] = e[2];
            });

            $scope.data = google.visualization.arrayToDataTable(plot);

            var options = {
                title:'nopat',
                hAxis:{title:'', minValue:0, maxValue:15},
                vAxis:{title:'Credits', minValue:0, maxValue:15},
                legend:'none'
            };

            $scope.chart = new google.visualization.ScatterChart(document.getElementById('chart_div'));

            google.visualization.events.addListener($scope.chart, 'select', $scope.selectHandler);

            $scope.chart.draw($scope.data, options);

            $scope.ready = true;
        });
});


//var app2 = angular.module('app2', []);
//
//app2.controller("MapController", function ($scope, $http) {
//    $scope.ready = false;
//
//
//    $scope.selectHandler = function(){
//        var selectedItem = $scope.chart.getSelection()[0];
//        if (selectedItem) {
//            var i = $scope.data.getValue(selectedItem.row, 0);
//            $scope.student = $scope.map[i];
//            $scope.$apply();
//            //open("http://rage.jamo.fi/students/" + map[i], '_self');
//
//            $http.get('api/student/' + $scope.map[i]).
//                success(function (data, status, headers, config) {
//                    $scope.student = data;
//                });
//        }
//    }
//
//    $http.get('api/groups/25/2012').
//        success(function (data, status, headers, config) {
//            $scope.plot = data.plot;
//
//            var plot = [];
//            angular.forEach(data.plot, function (e) {
//                plot.push([e[0], e[1]]);
//            });
//
//            $scope.map = {};
//            angular.forEach(data.plot, function (e) {
//                $scope.map[e[0]] = e[2];
//            });
//
//            $scope.data = google.visualization.arrayToDataTable(plot);
//
//            var options = {
//                title:'nopat',
//                hAxis:{title:'', minValue:0, maxValue:15},
//                vAxis:{title:'Credits', minValue:0, maxValue:15},
//                legend:'none'
//            };
//
//            $scope.chart = new google.visualization.ScatterChart(document.getElementById('chart_div'));
//
//            google.visualization.events.addListener($scope.chart, 'select', $scope.selectHandler);
//
//            $scope.chart.draw($scope.data, options);
//
//            $scope.ready = true;
//        });
//});

