import { ScreenshareService } from "@/bar/omnibar/screenshare/screenshare-service";
import { expect, test } from "vitest";
import { readFileSync } from "node:fs"

const sym = (service: ScreenshareService, fil: string) => {
    const file = readFileSync(`${__dirname}/fixtures/screenshare-${fil}.txt`).toString("utf-8");
    for (const line of file.split("\n")) {
        // unfortunately, the lines are trimmed when inputting them 
        // into ags.
        const trimmedLine = line.trimStart();

        service.parseLine(trimmedLine);
    }
}

test("should show charging when under percent", () => {
    const service = new ScreenshareService();
    sym(service, "start")
    expect(service.getRunning().find(v => v.id === "237")).to.contain({
        name: "chrome",
        state: "running",
        id: "237"
    })
    
    sym(service, "stop")
    expect(service.getRunning()).to.be.empty
    
    sym(service, "start")
    expect(service.getRunning().find(v => v.id === "237")).to.contain({
        name: "chrome",
        state: "running",
        id: "237"
    })
});
