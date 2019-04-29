/* jshint jasmine: true */

exports.defineAutoTests = function() {

    describe("EMMA globals", function () {

        it("EMMA should be exists", function() {
            expect(window.plugins.EMMA).toBeDefined();
        });

        it("EMMA method startSession", function(){        
            expect(window.plugins.EMMA.startSession).toBeDefined();
            expect(typeof window.plugins.EMMA.startSession).toBe('function');    
        });
    
        it("EMMA method startPush", function(){        
           expect(window.plugins.EMMA.startPush).toBeDefined();
            expect(typeof window.plugins.EMMA.startPush).toBe('function');
        });
    
        it("EMMA method trackLocation", function(){        
            expect(window.plugins.EMMA.trackLocation).toBeDefined();
            expect(typeof window.plugins.EMMA.trackLocation).toBe('function'); 
        });
    
        it("EMMA method trackEvent", function(){        
            expect(window.plugins.EMMA.trackEvent).toBeDefined();
            expect(typeof window.plugins.EMMA.trackEvent).toBe('function');  
        });
    
        it("EMMA method trackUserExtraInfo", function(){        
            expect(window.plugins.EMMA.trackUserExtraInfo).toBeDefined();
            expect(typeof window.plugins.EMMA.trackUserExtraInfo).toBe('function');
        });
    
        it("EMMA method loginUser", function(){        
            expect(window.plugins.EMMA.loginUser).toBeDefined();
            expect(typeof window.plugins.EMMA.loginUser).toBe('function');
        });
    
        it("EMMA method registerUser", function(){        
            expect(window.plugins.EMMA.registerUser).toBeDefined();
            expect(typeof window.plugins.EMMA.registerUser).toBe('function');   
        });
        
        it("EMMA method startOrder", function(){        
            expect(window.plugins.EMMA.startOrder).toBeDefined();
            expect(typeof window.plugins.EMMA.startOrder).toBe('function');
        });
    
        it("EMMA method addProject", function(){        
            expect(window.plugins.EMMA.addProject).toBeDefined();
            expect(typeof window.plugins.EMMA.addProject).toBe('function');   
        }); 

        it("EMMA method trackOrder", function(){        
            expect(window.plugins.EMMA.trackOrder).toBeDefined();
            expect(typeof window.plugins.EMMA.trackOrder).toBe('function');
        });
    
        it("EMMA method cancelOrder", function(){        
            expect(window.plugins.EMMA.cancelOrder).toBeDefined();
            expect(typeof window.plugins.EMMA.cancelOrder).toBe('function');   
        });

        it("EMMA method inAppMessage", function(){        
            expect(window.plugins.EMMA.inAppMessage).toBeDefined();
            expect(typeof window.plugins.EMMA.inAppMessage).toBe('function');   
        }); 

        it("EMMA method enableUserTracking", function(){        
            expect(window.plugins.EMMA.enableUserTracking).toBeDefined();
            expect(typeof window.plugins.EMMA.enableUserTracking).toBe('function');   
        });

        it("EMMA method disableUserTracking", function(){        
            expect(window.plugins.EMMA.disableUserTracking).toBeDefined();
            expect(typeof window.plugins.EMMA.disableUserTracking).toBe('function');   
        });
        
        it("EMMA method isUserTrackingEnabled", function(){        
            expect(window.plugins.EMMA.isUserTrackingEnabled).toBeDefined();
            expect(typeof window.plugins.EMMA.isUserTrackingEnabled).toBe('function');   
        });
    });
};