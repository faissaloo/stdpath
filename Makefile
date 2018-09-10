NAME=stdpath
RM := rm
DCC := dmd
DFLAGS += #-O -release -inline -boundscheck=off
LIBS =
SOURCEDIR = src
BUILDDIR = build
BIN=$(BUILDDIR)/bin
SRC = $(shell find $(SOURCEDIR) -name '*.d')
SRC_BASE = $(notdir $(SRC))
OBJS = $(addprefix $(BUILDDIR)/,$(SRC_BASE:%.d=%.o))

all: $(OBJS)
	$(DCC) $(DFLAGS) -of=$(BIN)/$(NAME) $(OBJS)

dbg:
	$(DCC) $(DFLAGS) -of=$(BIN)/$(NAME) $(OBJS)
test:
	$(DCC) $(DFLAGS) -unittest -run $(SRC)

clean:
	$(RM) -rf build *.lst

$(BUILDDIR)/%.o: $(SOURCEDIR)/%.d
	$(DCC) $(DFLAGS) -c $< -od=$(BUILDDIR)
