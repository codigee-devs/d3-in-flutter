import staticPlugin from "@elysiajs/static";
import { Elysia } from "elysia";

const server = new Elysia().use(staticPlugin());

server.get("/example-1", () => Bun.file("public/example-1.html"));
server.get("/example-2", () => Bun.file("public/example-2.html"));

server.listen(3000);
