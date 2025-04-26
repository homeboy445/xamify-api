const { auth } = require("../middlewares");

//express
const express = require("express");
const router = express.Router();

//prisma
const { PrismaClient, UserType } = require("@prisma/client");

const prisma = new PrismaClient();

router.get("/", auth(), async(req, res, next) => {
    try {
        const years = await prisma.year.findMany({});
        res.send(years);
    } catch (err) {
        console.log("## error in getting all years: ", err);
        next(err);
    }
});

router.get("/:id", auth(), async(req, res, next) => {
    try {
        const year = await prisma.year.findUnique({
            where: {
                id: req.params.id,
            },
        });
        res.send(year);
    } catch (err) {
        console.log("## error in getting year by id: ", err);
        next(err);
    }
});

router.post("/", auth({ type: UserType.TEACHER }), async(req, res, next) => {
    try {
        const year = await prisma.year.create({
            data: {
                label: req.body.label,
            },
        });
        res.send(year);
    } catch (err) {
        console.log("## error in creating year: ", err);
        next(err);
    }
});

router.delete(
    "/:id",
    auth({ type: UserType.TEACHER }),
    async(req, res, next) => {
        try {
            const year = await prisma.year.delete({
                where: {
                    id: req.params.id,
                },
            });

            res.send(year);
        } catch (err) {
            console.log("## error in deleting year: ", err);
            next(err);
        }
    }
);

router.patch(
    "/:id",
    auth({ type: UserType.TEACHER }),
    async(req, res, next) => {
        try {
            const { id } = req.params;
            const year = await prisma.year.update({
                where: {
                    id: id,
                },
                data: req.body,
            });
            res.send(year);
        } catch (err) {
            console.log("## error in updating year: ", err);
            next(err);
        }
    }
);

module.exports = router;