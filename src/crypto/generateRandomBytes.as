package crypto
{
    import flash.utils.ByteArray;
    
    import shell.Program;

    /**
     * Generates a sequence of random bytes.
     * 
     * <p>
     * Use <code>generateRandomBytes()</code> to generate cryptographic keys,
     * strong identifiers, session ids, and so on.
     * The random sequence is generated using cryptographically strong functions
     * provided by the operating system.
     * If the appropriate function is not available on an individual client
     * computer or device, then an error is thrown.
     * </p>
     * 
     * @param numberRandomBytes the number of random bytes to generate, between 1 and 1024.
     * @return a ByteArray containing the generated bytes.
     */
    public function generateRandomBytes( numberRandomBytes:uint ):ByteArray
    {
        if( numberRandomBytes < 1 )
        {
            numberRandomBytes = 1;
        }
        
        if( numberRandomBytes > 1024 )
        {
            numberRandomBytes = 1024;
        }
        
        var bytes:ByteArray = new ByteArray();
        
        var get2bytes:Function = function():uint
        {
            /* Note:
               This will only work under Linux and Mac OS X and only if
               "/dev/urandom" is available.
               We should test its presence and thorw an error if not found.
            */
            var str:String = Program.open( "LC_CTYPE=C tr -dc 'A-F0-9' < /dev/urandom | head -c 2" );
            var b:uint = parseInt( "0x" + str );
            return b;
        }
        
        var i:uint;
        for( i = 0; i < numberRandomBytes; i++ )
        {
            bytes.writeByte( get2bytes() );
        }
        
        bytes.position = 0;
        return bytes;
    }
}