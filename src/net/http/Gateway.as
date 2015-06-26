package net.http
{
    
    /**
     * The contract of an HTTP Gateway.
     */
    public interface Gateway
    {
        
        /**
         * The server environment variables.
         */
        function get environment():Environment;
        
        /**
         * The current server request that hit the gateway.
         */
        function get request():Request;
        
        /**
         * The errors stream that occured during the processing of the request.
         * 
         * <p>
         * In a CGI server process we can not output errors anywhere as it could
         * break the server response and produce an HTTP error 500, so we keep
         * a separate stream for the errors
         * (like a stderr in parallel of a stdout in an executable).
         * </p>
         */
        function get errors():String;
        /** @private */
        function set errors( value:String ):void;
        
        /**
         * Run the current server request.
         * 
         * <p>
         * This is the heart of the CGI processing server side.
         * When this function executes here what happen:
         * </p>
         * 
         * <ul>
         *   <li>
         *   From the server <code>environment</code> variables
         *   we gather: <code>requestMethod</code>, <code>contentType</code>,
         *   <code>contentLength</code>, and <code>querySring</code>.
         *   </li>
         *   <li>
         *   If the <code>requestMethod</code> is "POST" and the
         *   <code>contentLength</code> is bigger than zero we then
         *   read the post data.
         *   </li>
         *   <li>
         *   With all those variables we are building a <code>request</code> object.
         *   </li>
         *   <li>
         *   We pass this <code>request</code> object to the <code>apply()</code>
         *   function and assign the returned result to a <code>response</code> object.
         *   </li>
         *   <li>
         *   If the <code>apply()</code> call throws an error, we save it in the
         *   <code>errors</code> stream.
         *   </li>
         *   <li>
         *   If the returned <code>response</code> object is <code>null</code>
         *   or invalid, we assign a default response.
         *   </li>
         *   <li>
         *   If we find a non-empty <code>errors</code> stream, we change the
         *   <b>status</b> of the <code>response</code> to the default server error
         *   (in general "500 Internal Server Error"), and we append the
         *   <code>errors</code> at the top of the response <b>content</b>. 
         *   </li>
         *   <li>
         *   Finally, we call the functions <code>display()</code> and <code>flush()</code>
         *   on the <code>response</code> object to "render" as a stream of bytes
         *   the output to the client that made the request.
         *   </li>
         * </ul>
         */
        function run():void;
        
        /**
         * Pass a <code>request</code> object
         * to obtain a <code>response</code> object.
         */
        function apply( request:Request ):Response;
    }
}