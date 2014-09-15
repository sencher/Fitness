package utils {
    import flash.utils.Dictionary;

    public dynamic class Hash extends Dictionary {
        public function Hash(weakKeys:Boolean = false) {
            super(weakKeys);
        }

        public function get length():uint {
            return getKeys().length
        }

        public function getKeys():Array {
            var keys:Array = new Array();
            for (var key:Object in this) {
                keys.push(key);
            }
            return keys;
        }

        public function clear():void {
            var keys:Array = getKeys();
            var i:int, l:int = keys.length;

            for (i = 0; i < l; i++) {
                removeKey(keys[i]);
            }
        }

        public function getValues():Array {
            var values:Array = new Array();
            for (var key:Object in this) {
                values.push(getKey(key));
            }
            return values;
        }

        public function hasKey(key:Object):Boolean {
            return getKey(key) != null;
        }

        public function getKey(key:Object):Object {
            return this[key];
        }

        public function setKey(key:Object, value:Object):void {
            this[key] = value;
        }

        public function setKeyIfEmpty(key:Object, value:Object):void {
            if (!hasKey(key)) {
                setKey(key, value);
            }
        }

        public function removeKey(key:Object):Boolean {
            try {
                delete this[key];
            }
            catch (e:Error) {
                return false;
            }
            return true;
        }

        public function getOrSet(key:Object, value:Object):Object {
            if (!hasKey(key)) {
                setKey(key, value);
            }
            return getKey(key);
        }

        public static function from_object(object:Object):Hash {
            var hash:Hash = new Hash();
            for (var key:String in object) {
                hash.setKey(key, object[key]);
            }
            return hash;
        }

        public static function fromArray(a:Array):Hash {
            var hash:Hash = new Hash(), i:int;
            for (i = 0; i < a.length; i++) hash[i] = a[i];
            return hash;
        }

        public static function merge(main:Hash, second:Hash, override:Boolean = false):void {
            var i:Object;
            for (i in second) {
                if (override) {
                    main.setKey(i, second.getKey(i));
                } else {
                    main.setKeyIfEmpty(i, second.getKey(i));
                }
            }
        }

        public static function substract(main:Hash, second:Hash):void {
            var i:Object;
            for (i in second) {
                main.removeKey(i);
            }
        }

        public function toString():String {
            var i:Object;
            var string:String = "";
            for (i in this) {
                string += i + " " + getKey(i) + "\n";
            }
            return string;
        }

    }
}
