NAME=stdpath
RM := rm
MV := mv
DCC := dmd
DFLAGS +=
LIBS =
SOURCEDIR = src
BUILDDIR = build
BIN=$(BUILDDIR)/bin
SRC = $(shell find $(SOURCEDIR) -name '*.d')
SRC_BASE = $(notdir $(SRC))
OBJS = $(addprefix $(BUILDDIR)/,$(SRC_BASE:%.d=%.o))

all: $(OBJS)
	$(DCC) $(DFLAGS) -of=$(BIN)/$(NAME) $(OBJS)

install:
	$(DCC) $(DFLAGS) -O -release -inline -boundscheck=off -of=$(BIN)/$(NAME)-release $(SRC)
	$(MV) $(BIN)/$(NAME)-release /usr/bin

dbg:
	$(DCC) $(DFLAGS) -of=$(BIN)/$(NAME) $(OBJS)
test:
	$(DCC) $(DFLAGS) -unittest -run $(SRC)

clean:
	$(RM) -rf build *.lst

$(BUILDDIR)/%.o: $(SOURCEDIR)/%.d
	$(DCC) $(DFLAGS) -c $< -od=$(BUILDDIR)
