# Modelsim on Docker
ModelSim Version 16 GUI Running under docker container

## Steps for Linux:
First you need to exec the `xauth list` on your host terminal. The aprox result
will be: <br/>
`<hostname-of-machine>/unix: MIT-MAGIC-COOKIE-1 <some number here>` <br/>
Then exec `echo $DISPLAY`. The result will be **:1** or **:0** <br/>
Run the container with the following command: <br/>
`sudo docker run -i -t --name modelsim --net=host -e DISPLAY -v /tmp/.X11-unix goldensniper/modelsim-docker bash`

Now inside the container exec the following command: <br/>
`xauth add <hostname-of-machine>/unix:<no-of-display> MIT-MAGIC-COOKIE-1 <some number here>`

Where the third arg is the result of `xauth list` command on your host and 
`<no-of-display>` is the **$DISPLAY** host machine value. <br/>

Finally exec `vsim` and enjoy. :)

Example: <br/>
`xauth list` <br/>
![sc](https://user-images.githubusercontent.com/43972902/129357595-3713e40a-62b0-493e-95b4-bf8a2b05dc44.png)

`echo $DISPLAY` <br/>
![2](https://user-images.githubusercontent.com/43972902/129357943-7abbab00-86a7-43b9-82b1-e22972e0e206.png)

First usage modelsim docker command: <br/>
`docker run -i -t --name modelsim --net=host -e DISPLAY -v /tmp/.X11-unix goldensniper/modelsim-docker bash` <br/>
![3](https://user-images.githubusercontent.com/43972902/129358020-fb3d7812-ad52-4906-8705-07394ba3cb72.png)

After running container set XServer: <br/>
`xauth add mozerpol-pc/unix:0 MIT-MAGIC-COOKIE-1 fbcd4b1744cd112081823023de2e57ec`
<br/>
![3](https://user-images.githubusercontent.com/43972902/129358286-5d025787-94a4-4aff-bf79-9004408463c7.png)

After this you should can run *vsim*: <br/>
![4](https://user-images.githubusercontent.com/43972902/129358116-fc510cc4-7236-432f-9a15-cfb26f4ae898.png)

## How to use modelsim with docker
**How to run modelsim after installation:** <br/>
1. List all containers and note ID: `docker ps -a` <br/>
![1](https://user-images.githubusercontent.com/43972902/129359170-fcad70ab-2e8b-4eb3-aaa7-e4a6fdbbef3c.png)

2. Run docker: `docker start 563bcbca514b` <br/>
![2](https://user-images.githubusercontent.com/43972902/129359497-a6c24684-0e09-41ac-85fa-c9e4d05135f2.png)

3. Run modelsim: `docker exec -it 563bcbca514b vsim` <br/>
![q](https://user-images.githubusercontent.com/43972902/129359952-b831ac92-6590-4331-9cce-aad4bfcd3391.png) <br/>
Now you can notice that container change their ID: <br/>
![x](https://user-images.githubusercontent.com/43972902/129360141-bee778d0-35f5-4101-8903-770921d3fec4.png)

4. If you want stop docker just: `docker stop 563bcbca514b`
