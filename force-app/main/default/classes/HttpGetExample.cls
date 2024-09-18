public class HttpGetExample {
    public List<Post> posts { get; set; }
    
    public HttpGetExample() {
        posts = new List<Post>();
        fetchData();
    }
    
    public void fetchData(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            List<Object> jsonResponse = (List<Object>) JSON.deserializeUntyped(response.getBody());
            for (Object obj : jsonResponse) {
                Map<String, Object> postMap = (Map<String, Object>) obj;
                Post post = new Post();
                post.userId = (Integer) postMap.get('userId');
                post.id = (Integer) postMap.get('id');
                post.title = (String) postMap.get('title');
                post.body = (String) postMap.get('body');
                posts.add(post);
            }
            Integer i = 1;
            for(Post post : posts){
                System.debug(i + ' post: ' + post.userId);
                i++;
            }
             
        } else {
            System.debug('Error');
        }
    }
    
    public class Post {
        public Integer userId { get; set; }
        public Integer id { get; set; }
        public String title { get; set; }
        public String body { get; set; }
    }
}